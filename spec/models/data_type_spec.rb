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

require 'rails_helper'

RSpec.describe DataType, type: :model do
  let(:test_datatype) { create :data_type, name: 'Test Data Type', order: '2' }

  describe '#create' do
    context 'data type does not exist and' do
      it 'should allow a new data type to be valid with name and order' do
        expect(test_datatype).to be_valid
      end

      it 'should not allow a new data type without a name to be valid' do
        test_datatype.name = nil
        expect(test_datatype).to_not be_valid
      end

      it 'should set order before validation' do
        test_datatype.order = nil
        expect(test_datatype).to be_valid
      end

      it 'should not allow a new data type with an order less than 1' do
        test_datatype.order = 0
        expect(test_datatype).to_not be_valid
      end
    end
  end
end
