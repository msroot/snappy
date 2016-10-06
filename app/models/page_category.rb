# == Schema Information
#
# Table name: page_categories
#
#  id          :integer          not null, primary key
#  category_id :integer
#  page_id     :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class PageCategory < ApplicationRecord
  belongs_to :page  
  belongs_to :category  
end
