require 'redmine'
require 'gpgme'

Redmine::Plugin.register :redmine_encrypted_document_plugin do
  name 'Redmine Encrypted Document plugin'
  author 'Aleksei Gusev'
  description %s{
    This plugin provides ability to store documents
    encrypted by ring of pulic keys of a set of users.
    }
  version '0.0.1'

  # remapping permissions
  [ :view_documents, :manage_documents ].each do |pname|
    Redmine::AccessControl.permissions.delete_if { |p| p.name == pname }
  end
  project_module :documents do |map|
    map.permission( :view_documents,
                    :encrypted_documents => [:index, :show, :download])
    map.permission( :manage_documents,
                    { :encrypted_documents => [:new, :edit, :destroy, :add_attachment, :destroy_attachment]},
                    :require => :loggedin)
  end

  # remapping menus
  Redmine::MenuManager.items( :project_menu).delete_if { |mitem| mitem.name == :documents }
  menu( :project_menu, :documents,
        { :controller => 'encrypted_documents', :action => 'index' }, :param => :project_id,
        :caption => 'Documents')

  menu :top_menu, :gpgme, {:controller => 'gpgme', :action => 'index'}, :caption => 'GPGME'

  ENV['GNUPGHOME'] = "#{RAILS_ROOT}/gnupghome"
  
  RAILS_DEFAULT_LOGGER.info "Redmine Encrypted Document plugin is loaded. Public keys ring: " +
    GPGME.list_keys.join( ',')

  def GPGME.encrypt_always_trust(recipients, plain, *args_options)
    raise ArgumentError, 'wrong number of arguments' if args_options.length > 3
    args, options = split_args(args_options)
    cipher = args[0]
    recipient_keys = recipients ? resolve_keys(recipients, false) : nil

    RAILS_DEFAULT_LOGGER.info "GnuPG: #{ENV['GNUPGHOME']}"
    RAILS_DEFAULT_LOGGER.info "recipients: #{recipients}"
    RAILS_DEFAULT_LOGGER.info "recipient_keys: #{recipient_keys}"
#     recipient_keys.each do |key|
#       RAILS_DEFAULT_LOGGER.info "key: #{key}"
#     end
    
    ctx = GPGME::Ctx.new(options)
    plain_data = input_data(plain)
    cipher_data = output_data(cipher)
    begin
      if options[:sign]
        if options[:signers]
          ctx.add_signer(*resolve_keys(options[:signers], true))
        end
        ctx.encrypt_sign(recipient_keys, plain_data, cipher_data, GPGME::ENCRYPT_ALWAYS_TRUST)
      else
        ctx.encrypt(recipient_keys, plain_data, cipher_data, GPGME::ENCRYPT_ALWAYS_TRUST)
      end
    rescue GPGME::Error::UnusablePublicKey => exc
      exc.keys = ctx.encrypt_result.invalid_recipients
      raise exc
    rescue GPGME::Error::UnusableSecretKey => exc
      exc.keys = ctx.sign_result.invalid_signers
      raise exc
    end

    unless cipher
      cipher_data.seek(0, IO::SEEK_SET)
      cipher_data.read
    end
  end
end
