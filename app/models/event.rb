# == Schema Information
#
# Table name: events
#
#  id             :integer          not null, primary key
#  description    :text(65535)
#  name           :string(255)
#  start_time     :datetime
#  end_time       :datetime
#  page_id        :integer
#  place_id       :integer
#  fb_id          :string(255)
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  cover_url      :text(65535)
#  cover_offset_y :integer          default(0)
#  cover_offset_x :integer          default(0)
#

class Event < ApplicationRecord
  belongs_to :page
  belongs_to :place
  validates_uniqueness_of :fb_id
  
  default_scope { order(start_time: 'ASC') }

  def human_end_time
    date_for_humans end_time if end_time.present?
  end
  
    
  def human_start_time
    date_for_humans start_time if start_time.present?
  end
  
  def to_param  
    place_name  = place.present? ? "-at-#{place.name.to_slug.normalize.to_s}" : ""
    "#{id}-#{name.to_slug.normalize.to_s}#{place_name}"
  end
         
  def address
    self.place.try(:location) ? self.place.location.address : self.place.name  
  end
  
  
  def facebook_link
    "https://www.facebook.com/#{fb_id}"
  end
  
  # Event.delete_expired
  def self.delete_expired
    Event.where('end_time < ?', Time.now.beginning_of_month).destroy_all
    Event.where('start_time < ?', Time.now.beginning_of_month).destroy_all
  end



  def as_json_with_associations
    json = self.as_json
    json.merge!(page: self.page.as_json.merge!(
      categories: self.page.categories.as_json )
    )
    
    if self.place.present?
      json_place =   self.place.as_json
      json_place.merge!(location: place.location.as_json) if self.place.location
      json.merge!(place: json_place)
    end
    
    json
  end

  
  private
  def date_for_humans date
    if date.today?
      "Today #{date.strftime("at %I:%M%p")}"
    elsif date.to_date == Date.current.tomorrow
      "Tomorrow #{date.strftime("at %I:%M%p")}" 
    else
      date.to_s(:short)
    end        
  end
end
