class EncryptedDocumentsController < DocumentsController
  unloadable

  helper :encrypted_attachments
  include EncryptedAttachmentsHelper

  def new
    params[:document][:project_id] = @project.id
    parse_params_document_recipients
    @document = EncryptedDocument.new( params[:document])
    if request.post? and @document.save
      attach_encrypted_files(@document, params[:attachments])
      flash[:notice] = l(:notice_successful_create)
      Mailer.deliver_document_added(@document) if Setting.notified_events.include?('document_added')
      redirect_to :action => 'index', :project_id => @project
    end
  end

  def edit
    parse_params_document_recipients
    @categories = Enumeration::get_values('DCAT')
    if request.post? and @document.update_attributes(params[:document])
      EncryptedAttachment.find_all_by_container_type_and_container_id( 'document', @document.id).each do |a|
        RAILS_DEFAULT_LOGGER.info a.diskfile
        a.re_encrypt!
      end
      flash[:notice] = l(:notice_successful_update)
      redirect_to :action => 'show', :id => @document
    end
  end  

  def add_attachment
    attachments = attach_encrypted_files(@document, params[:attachments])
    Mailer.deliver_attachments_added(attachments) if !attachments.empty? && Setting.notified_events.include?('document_added')
    redirect_to :action => 'show', :id => @document
  end

#   def find_recipients
#     @phrase = params[:recipient_search]
#     @candidates = User.find( :all, :conditions => [ "mail LIKE ?", "%#{@phrase}%" ])
#     render :inline => "<%= auto_complete_result( @candidates.collect { |c| c.mail }, @phrase) %>"
  #   end

  private
  
  def find_document
    @document = EncryptedDocument.find(params[:id])
    @project = @document.project
  rescue ActiveRecord::RecordNotFound
    render_404
  end

  def parse_params_document_recipients
    if params[:document] && params[:document][:recipients]
      params[:document][:recipients] = params[:document][:recipients].values
      params[:document][:recipients].delete_if { |r| r.blank? }
    end
  end

end
