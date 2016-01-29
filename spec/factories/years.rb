# == Schema Information
#
# Table name: years
#
#  id         :integer          not null, primary key
#  year       :integer          not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

FactoryGirl.define do
  factory :year do
    sequence :year, 1994
  end
end
