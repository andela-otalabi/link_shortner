class LinksController < ApplicationController
  before_action :find_link, only: [:statistics, :destroy]
  def index
    @link = Link.new
    if current_user
     @links = current_user.links.most_recent.all
    else
    @links = Link.anonymous_links
  end
  end

  def create
   @link = Link.new(link_params)
   @link.user_id = current_user.id if current_user
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
    @user_agent = UserAgent.parse(request.env["HTTP_USER_AGENT"])
    @link = Link.find_by(short_link: params[:short_link])
    save_click_details(@link)
    original_link = (@link.short_link.include? "http") ? @link.original_link : "http://#{@link.original_link}"
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
    country_stats(@link)
    browser_stats(@link)
    device_stats(@link)
  end

  def destroy
    @link = find_link
    @link.delete
    redirect_to current_user
  end

  def sort
    @links = current_user.links.popularity.all
    respond_to do |format|
      format.js
      format.html
    end
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

  def country_stats(link)
    @countries = link.clicks
    @country_frequencies = Hash.new(0)
    @countries.each do |country| 
      @country_frequencies[country.country_name] += 1
    end
    @country_frequencies = @country_frequencies.sort_by { |country, count| count}
  end

  def browser_stats(link)
    @browsers = link.clicks
    @browser_types = Hash.new(0)
    @browsers.each do |browser| 
      @browser_types[browser.browser_type] += 1
    end
  end

  def device_stats(link)
    @devices = link.clicks
    @devices_types = Hash.new(0)
    @devices.each do |device| 
     @devices_types[device.device] += 1
    end
  end
end