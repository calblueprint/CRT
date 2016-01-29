# == Schema Information
#
# Table name: years
#
#  id         :integer          not null, primary key
#  year       :integer          not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'rails_helper'

RSpec.describe Year, type: :model do
end
