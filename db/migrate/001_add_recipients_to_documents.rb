class AddRecipientsToDocuments < ActiveRecord::Migration
  def self.up
    add_column :documents, :recipients, :text
  end

  def self.down
    remove_column :documents, :recipients
  end
end
