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

FactoryGirl.define do
  factory :attribute do
    type 1
value "9.99"
  end

end
