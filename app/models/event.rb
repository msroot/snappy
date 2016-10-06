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

  def self.default_scope 
      order('start_time DESC')
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
end
