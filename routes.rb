map.connect 'projects/:project_id/documents/:action', :controller => 'encrypted_documents'

map.connect 'attachments/:id', :controller => 'encrypted_attachments', :action => 'show', :id => /\d+/
map.connect 'attachments/:id/:filename', :controller => 'encrypted_attachments', :action => 'show', :id => /\d+/, :filename => /.*/
map.connect 'attachments/download/:id/:filename', :controller => 'encrypted_attachments', :action => 'download', :id => /\d+/, :filename => /.*/
