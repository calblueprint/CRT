# == Schema Information
#
# Table name: data_types
#
#  id         :integer          not null, primary key
#  formula    :string
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  order      :integer
#  master     :boolean          default(FALSE)
#

FactoryGirl.define do
  factory :data_type do
    formula "data_type_formula"
    sequence :name do |n|
      "data_type_name #{n}"
    end
    sequence :order
  end
end
