class EncryptedDocument < Document
  unloadable
  set_table_name 'documents'
  
  serialize :recipients

  def validate
    if @attributes['recipients']
      @attributes['recipients'].each do |r|
        errors.add :recipients, "one of the recipients is unknown" if GPGME.resolve_keys( r, false).empty?
      end
    end
  end

end
