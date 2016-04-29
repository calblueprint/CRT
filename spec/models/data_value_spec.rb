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

require 'rails_helper'
require 'spec_helper'

RSpec.describe DataValue, type: :model do
  let(:data_value) { create :data_value }
  let(:data_value_formula) { create :data_value, input_formula: "1 + 3" }

  describe '#create' do
    it 'should have valid data_type_id' do
      new_data_value = build :data_value
      new_data_value.data_type_id = nil
      expect(new_data_value).to_not be_valid
    end
  end

  describe '#formula' do
    it 'should have same formula as data type' do
      dt = data_value.data_type
      expect(data_value.formula).to eq(dt.formula)
    end

    it 'should have different formula as data type' do
      dt = data_value_formula.data_type
      expect(data_value_formula.formula).to_not eq(dt.formula)
    end
  end
end
