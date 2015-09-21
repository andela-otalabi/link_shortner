class LinksController < ApplicationController
  before_action :find_link, only: [:statistics, :update, :destroy]
  def index
    @link = Link.new
    if current_user
     @links = (current_user.links.most_recent).limit(6)
    else
      @links = (Link.anonymous_links.most_recent).limit(6)
    end
  end

  def create
   @link = Link.new(link_params)
   @link.user_id = current_user.id if current_user
    respond_to do |format|
      if @link.save
        format.js 
        format.html {redirect_to links_path}
      else
        flash[:warning] = "Enter a valid URL"
        format.js {}
        format.html {render action: 'new'}
      end
    end 
  end

  def show
    @user_agent = UserAgent.parse(request.env["HTTP_USER_AGENT"])
    @link = Link.find_by(short_link: params[:short_link])
    save_click_details(@link)
    original_link = (@link.original_link.include? "http") ? @link.original_link : "http://#{@link.original_link}"
    redirect_to original_link
    @link.increment_visits
  end

  def edit
    @link = find_link
  end

  def update
    @link = find_link
    respond_to do |format|
      if @link.update(link_params)
       flash[:success] = "Link updated successfully" 
       format.html { redirect_to :back } 
      else
       flash[:danger] = "Error updating link" 
       format.html { redirect_to :back }
      end
    end
  end

  def statistics
    @link = find_link
    if @link.user_id == current_user.id
      @country_frequencies = find_number_of_rows(@link, "country_name")
      @browser_types = find_number_of_rows(@link, "browser_type")
      @devices_types = find_number_of_rows(@link, "device")
    else
      redirect_to root_path
    end
  end

  def destroy
    @link = find_link
    @link.delete
    redirect_to current_user
  end
 
 private
   def find_link
     @find_link = Link.find(params[:id])
   end 

  def link_params
    params.require(:link).permit(:original_link, :short_link)
  end

  def save_click_details(link)
    user_agent = UserAgent.parse(request.env["HTTP_USER_AGENT"])
    click = link.clicks.new
    if user_agent.mobile? == false
      click.device = "Web"
    else
      click.device = "Mobile" 
    end
    click.ip_address = request.remote_ip
    click.city = request.location.data["city"]
    click.country_name = request.location.data["country_name"]
    click.browser_type = user_agent.browser
    click.save
  end

  def find_number_of_rows(link, column_name)
    clicks = link.clicks
    @frequency = Hash.new(0)
    clicks.each do |click|
      if column_name == "country_name"
        @frequency[click.country_name] += 1
      elsif column_name == "browser_type"
        @frequency[click.browser_type] += 1
      else
        @frequency[click.device] += 1
      end
    end
    @frequency
  end
end