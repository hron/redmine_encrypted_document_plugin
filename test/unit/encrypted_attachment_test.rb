require File.dirname(__FILE__) + '/../test_helper'

class EncryptedAttachmentTest < Test::Unit::TestCase
  fixtures :documents, :users

  def setup
    ENV['GNUPGHOME'] = RAILS_ROOT + "/vendor/plugins/redmine_encrypted_document_plugin/test/fixtures/gnupghome"
  end

  def test_create_encrypted_attachment
    EncryptedAttachment.create( :container => documents( :documents_001),
                                :file => test_uploaded_file('testfile.txt', 'text/plain'),
                                :description => 'Testing encrypted attachments.',
                                :author => users( :users_001),
                                :recepients => [ 'aleksei.gusev@gmail.com',
                                                 'nikolay.neborsky@warecorp.com'])
    EncryptedAttachment.create( :container => documents( :documents_001),
                                :file => test_uploaded_file('060719210727_archive.zip', 'application/zip'),
                                :description => 'Testing encrypted attachments.',
                                :author => users( :users_001))
  end
end
