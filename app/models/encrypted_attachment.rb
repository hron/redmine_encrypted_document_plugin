class EncryptedAttachment < Attachment
  unloadable
  set_table_name 'attachments'

  # Copy temp file to its final location, encrypt the content if needed.
  def before_save
    if @temp_file && (@temp_file.size > 0)
      logger.debug("saving '#{self.diskfile}'")
      File.open(diskfile, "wb") do |f| 
        if !( @container.recipients.nil? || @container.recipients.empty?)
          self.content_type = 'application/pgp-encrypted'
          f.write(GPGME.encrypt_always_trust(@container.recipients, @temp_file.read))
        else
          f.write(@temp_file.read)
        end
      end
      self.digest = self.class.digest(diskfile)
    end
    # Don't save the content type if it's longer than the authorized length
    if self.content_type && self.content_type.length > 255
      self.content_type = nil
    end
  end

  private

  def sanitize_filename( value)
    @filename = unless @container.recipients.nil? || @container.recipients.empty?
                  super( value) + '.gpg'
                else
                  super( value)
                end
  end

  # Returns an ASCII or hashed filename
  def self.disk_filename( filename)
    df = super( filename)
    unless @container.recipients.nil? || @container.recipients.empty?
      df += '.gpg'
    end
    df
  end
end
