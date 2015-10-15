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

require 'rails_helper'

RSpec.describe Attribute, :type => :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
