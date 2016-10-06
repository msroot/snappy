# == Schema Information
#
# Table name: places
#
#  id          :integer          not null, primary key
#  name        :string(255)
#  location_id :integer
#  fb_id       :string(255)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class Place < ApplicationRecord
  belongs_to :location
  has_many :events, dependent: :destroy
  validates_uniqueness_of :fb_id
end
