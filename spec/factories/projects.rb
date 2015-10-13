# == Schema Information
#
# Table name: projects
#
#  id                   :integer          not null, primary key
#  name                 :string
#  acres                :integer
#  date_closed          :date
#  restricted_endowment :decimal(, )
#  cap_rate             :decimal(, )
#  admin_rate           :decimal(, )
#  total_upfront        :decimal(, )
#  years_upfront        :integer
#  earnings_begin       :date
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#

FactoryGirl.define do
  factory :project do
    name "MyString"
acres 1
date_closed "2015-09-30"
restricted_endowment "9.99"
cap_rate "9.99"
admin_rate "9.99"
total_upfront "9.99"
years_upfront ""
earnings_begin "2015-09-30"
  end

end
