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
#  input_type :integer          default(0)
#

FactoryGirl.define do
  factory :data_type do
    formula "data_type_formula"
    sequence :name do |n|
      "data_type_name #{n}"
    end
  end
end
