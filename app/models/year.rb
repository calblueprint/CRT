# == Schema Information
#
# Table name: years
#
#  id         :integer          not null, primary key
#  date       :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Year < ActiveRecord::Base
  belongs_to :project
end
