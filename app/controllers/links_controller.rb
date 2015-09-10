class LinksController < ApplicationController
  def index
    @link = Link.new
    @links = Link.all
  end

  def create
   @link = Link.new(link_params)
    respond_to do |format|
      if @link.save
        format.js 
        format.html {redirect_to links_path, notice: 'Link was successfully shortened.'}
      else
        format.html {render action: 'new'  }
      end
    end  
  end

  def show
    if params[:short_link]
      @link = Link.find_by(short_link: params[:short_link])
      original_link = (@link.short_link.include? "http") ? @link.original_link : "http://#{@link.original_link}"
      if redirect_to original_link
        @link.increment_visits
      end
    end
  end

  def destroy
  end
 
 private
  def link_params
    params.require(:link).permit(:original_link, :short_link)
  end

end