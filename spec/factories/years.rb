# == Schema Information
#
# Table name: years
#
#  id         :integer          not null, primary key
#  date       :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

FactoryGirl.define do
  factory :year do
    date 1
  end
end
