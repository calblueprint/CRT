# == Schema Information
#
# Table name: attributes
#
#  id         :integer          not null, primary key
#  type       :integer
#  value      :decimal(, )
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  year_id    :integer
#

class Attribute < ActiveRecord::Base
end
