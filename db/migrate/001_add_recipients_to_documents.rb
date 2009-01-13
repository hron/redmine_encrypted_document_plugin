class AddRecipientsToDocuments < ActiveRecord::Migration
  def self.up
    add_column :documents, :type, :string
    add_column :documents, :recipients, :text
  end

  def self.down
    remove_column :documents, :recipients
    remove_column :documents, :type
  end
end
