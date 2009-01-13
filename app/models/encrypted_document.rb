class EncryptedDocument < ActiveRecord::Base
  set_table_name 'documents'
  
  belongs_to :project
  belongs_to :category, :class_name => "Enumeration", :foreign_key => "category_id"
  has_many :attachments, :as => :container, :dependent => :destroy

  acts_as_searchable :columns => ['title', "#{table_name}.description"], :include => :project
  acts_as_event :title => Proc.new {|o| "#{l(:label_document)}: #{o.title}"},
                :author => Proc.new {|o| (a = o.attachments.find(:first, :order => "#{Attachment.table_name}.created_on ASC")) ? a.author : nil },
                :url => Proc.new {|o| {:controller => 'documents', :action => 'show', :id => o.id}}
  acts_as_activity_provider :find_options => {:include => :project}

  validates_presence_of :project, :title, :category
  validates_length_of :title, :maximum => 60

  serialize :recipients

  def validate
    if @attributes['recipients']
      @attributes['recipients'].each do |r|
        errors.add :recipients, "one of the recipients is unknown" if GPGME.resolve_keys( r, false).empty?
      end
    end
  end

end
