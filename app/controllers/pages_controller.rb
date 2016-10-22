class PagesController < ApplicationController
  before_action :set_page, only: [:show, :import]

  # GET /pages
  def import
    @page.import
    redirect_to @page
  end

  def import_all
    ImportEventsJob.perform_later(Page.all.to_ary)
    redirect_to pages_path, notice: "Start Importing Events from #{Page.count} pages" 
  end
  
  # GET /pages
  def index
    @pages = Page.all
  end

  # GET /pages/1
  def show
    # @stats = [Page, Location, Place, Event].map{|c| [c.name, c.count]}.to_h
    # [Place, Location, Event].map{|c| c.destroy_all}
  end

  # GET /pages/new
  def new
    @page = Page.new
  end


  # POST /pages
  def create
    token = ENV['FB_TOKEN'] || fail('No facebook token set')
    origin_url = page_params[:origin_url].gsub('/pg/', '')
    origin_url = origin_url.split("/")[3].strip
    url = "https://graph.facebook.com/v2.7/#{origin_url}/?fields=category_list,name&access_token=#{token}"
    
    response = Net::HTTP.get_response(URI(url))
    
    unless response.is_a? Net::HTTPOK
      new_origin_url = origin_url.split("-").last
      url = "https://graph.facebook.com/v2.7/#{new_origin_url}/?fields=category_list,name&access_token=#{token}"
      response = Net::HTTP.get_response(URI(url))
    end
    
    object = JSON.parse(response.body, object_class: OpenStruct)
    
    if @page = Page.find_by_fb_id(object.id)
      redirect_to @page, notice: "Page allready added" and return
    end
    
        
    @page = Page.new(origin_url: origin_url, name: object.name, fb_id: object.id)

    if @page.save
      if object.category_list
        @page.categories = object.category_list.map { |e| Category.find_or_create_by(name: e.name)}.uniq
      end
        
      ImportEventsJob.perform_later(@page)
      redirect_to @page, notice: 'Page was successfully created.'
    else
      render :new, notice: "Invalid page"
    end
  end

  # # PATCH/PUT /pages/1
  # def update
  #   if @page.update(page_params)
  #     redirect_to @page, notice: 'Page was successfully updated.'
  #   else
  #     render :edit
  #   end
  # end
  #
  # # DELETE /pages/1
  # def destroy
  #   @page.destroy
  #   redirect_to pages_url, notice: 'Page was successfully destroyed.'
  # end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_page
    @page = Page.find(params[:id])
  end

  # Only allow a trusted parameter "white list" through.
  def page_params
    params.require(:page).permit(:origin_url, category_ids: [])
  end
end
