class GpgmeController < ApplicationController
  unloadable
  
  def index
    @keys = GPGME.list_keys
  end
  
  def import_key
    if request.post?
      if GPGME.import( params[:public_key_asc]).imported == 1
        flash[:notice] = "Successful"
        redirect_to :action => 'index'
      else
        flash[:error] = "Error"
      end
    end
  end
end
