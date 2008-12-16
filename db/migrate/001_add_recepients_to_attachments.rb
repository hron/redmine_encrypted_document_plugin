class AddRecepientsToAttachments < ActiveRecord::Migration
  def self.up
    add_column :attachments, :recepients, :text
  end

  def self.down
    remove_column :attachments, :recepients
  end
end
