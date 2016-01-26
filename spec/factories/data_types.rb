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
#  general    :boolean
#

FactoryGirl.define do
  factory :data_type do
    formula "data_type_formula"
    name "data_type_name"
  end
end
