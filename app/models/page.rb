# == Schema Information
#
# Table name: pages
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  fb_id      :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  origin_url :string(255)
#

class Page < ApplicationRecord
  has_many :events, dependent: :destroy
  validates :name, presence: true
  validates :fb_id, presence: true
  validates_uniqueness_of :fb_id, :message => "Page has been added already"

  has_many :page_categories  
  has_many :categories, :through => :page_categories

  
    
  accepts_nested_attributes_for :categories, allow_destroy: true

  def to_param  
    "#{id}-#{name.to_slug.normalize.to_s}"
  end

  def facebook_link
    "https://www.facebook.com/#{fb_id}"
  end

  # Page.all.map(&:import)
  def import
    token = ENV['FB_TOKEN'] || fail('No facebook token set')
    url = "https://graph.facebook.com/v2.7/#{fb_id}/events?fields=end_time,start_time,place,id,description,name,cover&access_token=#{token}"
    
    uri = URI(url)
    response = Net::HTTP.get(uri)
    object = JSON.parse(response, object_class: OpenStruct)


    object.data.map do |event|
      next if self.events.where(fb_id: event.id).present?
      next if Chronic.parse(event.start_time) < Time.now.beginning_of_month
      # events must have start but not end
      # next if Chronic.parse(event.end_time) < Time.now.beginning_of_month

      e = self.events.new
      e.name = event.name
      e.description = event.description
      e.start_time = Chronic.parse(event.start_time)
      e.end_time = Chronic.parse(event.end_time)
      e.fb_id  = event.id
      
      if event.cover
        e.cover_url  = event.cover.source 
        e.cover_offset_y  = event.cover.offset_y 
        e.cover_offset_x  = event.cover.offset_x 
      end
      
      if event.place
        place_attributes = event.place.to_h.slice(:fb_id, :name)
        place = Place.where(place_attributes).first
        place = Place.new(place_attributes) unless place
        

        if (location = event.place.location).present?
          location_attributes = location.to_h.slice(:city,:country,:latitude,:longitude,:street,:zip)
          location = Location.find_or_create_by(location_attributes)
          place.location = location
        end
        
        place.save(:validate => false)
        
        
        e.place = place 
        e.save
      end
      
    end if object and object.data.is_a? Array
    self.touch
  end
end
