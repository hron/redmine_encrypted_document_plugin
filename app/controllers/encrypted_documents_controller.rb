class EncryptedDocumentsController < DocumentsController
  unloadable

#   before_filter :find_project,  :only   => [ :index, :new, :find_recipients]
#   before_filter :find_document, :except => [ :index, :new, :find_recipients]
#   before_filter :authorize,     :except => [ :find_recipients ]

  def new
    params[:encrypted_document][:project_id] = @project.id
    if params[:encrypted_document][:recipients]
      params[:encrypted_document][:recipients] = params[:encrypted_document][:recipients].values
      params[:encrypted_document][:recipients].delete_if { |r| r.blank? }
    end
    @encrypted_document = EncryptedDocument.new( params[:encrypted_document])
    if request.post? and @encrypted_document.save
      attach_files(@encrypted_document, params[:attachments])
      flash[:notice] = l(:notice_successful_create)
      Mailer.deliver_document_added(@encrypted_document) if Setting.notified_events.include?('document_added')
      redirect_to :action => 'index', :project_id => @project
    end
  end

#   def find_recipients
#     @phrase = params[:recipient_search]
#     @candidates = User.find( :all, :conditions => [ "mail LIKE ?", "%#{@phrase}%" ])
#     render :inline => "<%= auto_complete_result( @candidates.collect { |c| c.mail }, @phrase) %>"
  #   end

end
