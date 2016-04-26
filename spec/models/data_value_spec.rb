# == Schema Information
#
# Table name: data_values
#
#  id              :integer          not null, primary key
#  type            :integer
#  value           :decimal(, )
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  data_type_id    :integer          not null
#  project_year_id :integer          not null
#  formula_value   :decimal(, )
#  input_formula   :string
#
# Indexes
#
#  index_data_values_on_data_type_id  (data_type_id)
#

require 'rails_helper'

RSpec.describe DataValue, type: :model do
  let(:data_value) { create :data_value, value: 10.0 }
  let(:data_value_formula) { create :data_value, input_formula: "1 + 3" }

  describe '#create' do
    it 'should have valid data_type_id' do
      new_data_value = build :data_value
      new_data_value.data_type_id = nil
      expect(new_data_value).to_not be_valid
    end
  end
end
