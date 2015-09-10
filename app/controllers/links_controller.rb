class LinksController < ApplicationController
  def index
    @links = Link.all
    @link = Link.new
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
      if redirect_to @link.original_link
        @link.visits += 1
        @link.save
      end
    else
      @link = Link.find(params[:short_link])
    end
  end

  def update
    @link = Link.find(params[:id])
    @link.update_attribute(:visits, visits + 1 )
  end

  def destroy
  end
 
 private
  def link_params
    params.require(:link).permit(:original_link, :short_link)
  end

end