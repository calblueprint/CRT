# == Schema Information
#
# Table name: data_values
#
#  id              :integer          not null, primary key
#  type            :integer
#  value           :decimal(19, 4)
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  data_type_id    :integer          not null
#  project_year_id :integer          not null
#  formula_value   :decimal(19, 4)
#  input_formula   :string
#
# Indexes
#
#  index_data_values_on_data_type_id  (data_type_id)
#

FactoryGirl.define do
  factory :data_value do
    project_year
    data_type
  end
end
