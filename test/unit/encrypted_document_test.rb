require File.dirname(__FILE__) + '/../test_helper'

class EncryptedDocumentTest < Test::Unit::TestCase
  fixtures :projects, :users, :roles, :members, :enabled_modules, :documents, :enumerations

  def setup
    @controller = DocumentsController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    User.current = nil
  end

#   def test_new_with_one_attachment
#     @request.session[:user_id] = 2
#     set_tmp_attachments_directory
    
#     post :new, :project_id => 'ecookbook',
#       :document => { :title => 'DocumentsControllerTest#test_post_new',
#       :description => 'This is a new document',
#       :category_id => 2},
#       :attachments => {'1' => {'file' => test_uploaded_file('testfile.txt', 'text/plain')}}
    
#     assert_redirected_to 'projects/ecookbook/documents'
    
#     document = Document.find_by_title('DocumentsControllerTest#test_post_new')
#     assert_not_nil document
#     assert_equal Enumeration.find(2), document.category
#     assert_equal 1, document.attachments.size
#     assert_equal 'testfile.txt', document.attachments.first.filename
#   end
end
