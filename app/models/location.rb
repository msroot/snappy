# == Schema Information
#
# Table name: locations
#
#  id         :integer          not null, primary key
#  city       :string(255)
#  country    :string(255)
#  latitude   :decimal(10, 6)
#  longitude  :decimal(10, 6)
#  street     :string(255)
#  zip        :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  state      :string(255)
#

class Location < ApplicationRecord
  acts_as_mappable   :lat_column_name => :latitude,
  :lng_column_name => :longitude
                     
  # Athens [37.9543593,23.7028389]
  # Pacha [41.97577,21.408733]
  # Location.within(5, :units => :kms, :origin => [41.97577,21.408733])                 
  def self.find_within origin= []
    Location.within(20, :units => :kms, :origin => origin)
  end

  def lat_long
    [latitude, longitude]
  end

  def address 
    [city, country, street, zip].join(", ")
  end

end
