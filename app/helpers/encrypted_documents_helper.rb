module EncryptedDocumentsHelper
  def attach_encrypted_files( obj, keys, attachments)
    attached = []
    if attachments && attachments.is_a?(Hash)
      attachments.each_value do |attachment|
        file = attachment['file']
        next unless file && file.size > 0
        a = Attachment.create(:container => obj, 
                              :file => file,
                              :description => attachment['description'].to_s.strip,
                              :author => User.current)
        attached << a unless a.new_record?
      end
    end
    attached
  end
end
