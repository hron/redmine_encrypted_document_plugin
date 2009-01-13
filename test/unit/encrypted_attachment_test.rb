require File.dirname(__FILE__) + '/../test_helper'

class EncryptedAttachmentTest < Test::Unit::TestCase
  fixtures :documents, :users

  def setup
    ENV['GNUPGHOME'] = RAILS_ROOT + "/vendor/plugins/redmine_encrypted_document_plugin/test/fixtures/gnupghome"
  end

  def test_create_encrypted_attachment
    enc_document = EncryptedDocument.find(2)
    enc_attach = EncryptedAttachment.new( :container => enc_document,
                                          :file => test_uploaded_file('060719210727_archive.zip', 'application/zip'),
                                          :description => 'Testing encrypted attachments.',
                                          :author => users( :users_001))
    assert_nothing_raised do
      enc_attach.save!
    end
    assert enc_attach.filename =~ /.gpg$/
    assert enc_attach.content_type == 'application/pgp-encrypted'
  end
end
