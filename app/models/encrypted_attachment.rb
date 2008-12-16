class EncryptedAttachment < Attachment
  set_table_name 'attachments'

  serialize :recepients

  # Copy temp file to its final location, encrypt the content if needed.
  def before_save
    if @temp_file && (@temp_file.size > 0)
      logger.debug("saving '#{self.diskfile}'")
      File.open(diskfile, "wb") do |f| 
        if recepients.nil? || recepients.empty?
          self.content_type = 'application/pgp-encrypted'
          f.write(@temp_file.read)
        else
          f.write(GPGME.encrypt_always_trust(recepients, @temp_file.read))
        end
      end
      self.digest = self.class.digest(diskfile)
    end
    # Don't save the content type if it's longer than the authorized length
    if self.content_type && self.content_type.length > 255
      self.content_type = nil
    end
  end
end
