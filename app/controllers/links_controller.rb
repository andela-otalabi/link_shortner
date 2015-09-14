class LinksController < ApplicationController
  before_action :find_link, only: [:statistics, :destroy]
  def index
    @link = Link.new
    @links = Link.all
  end

  def create
   @link = Link.new(link_params)
   @link.user_id = current_user.id if current_user
    respond_to do |format|
      if @link.save
        @links = Link.all
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

  def statistics
    clicks_country_frequency(@find_link)
  end

  def destroy
     @find_link.delete
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
    click.ip_address = request.remote_ip
    click.city = request.location.data["city"]
    click.country_name = request.location.data["country_name"]
    click.browser_type = user_agent.browser
    click.device = user_agent.mobile?
    click.save
  end

  def clicks_country_frequency(link)
    @countries = link.clicks
    @country_frequencies = Hash.new(0)
    @countries.each do |country| 
      @country_frequencies[country.country_name] += 1
    end
    @country_frequencies = @country_frequencies.sort_by { |country, count| count}
  end

end