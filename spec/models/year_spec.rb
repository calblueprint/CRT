# == Schema Information
#
# Table name: years
#
#  id         :integer          not null, primary key
#  year       :integer          not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'rails_helper'

RSpec.describe Year, type: :model do
  let(:test_year) { create :year, year: 2016 }

  describe '#create' do
    context 'year does not exist and' do
      it 'should allow a new year to be valid' do
        expect(test_year).to be_valid
      end

      it 'should not allow a new year without a year' do
        test_year.year = nil
        expect(test_year).to_not be_valid
      end

      it 'should not allow a new year without a valid numerical year' do
        test_year.year = -1
        expect(test_year).to_not be_valid
        test_year.year = 1_000_000
        expect(test_year).to_not be_valid
      end
    end
    context 'year does exists and' do
      it 'should not allow a new year to be valid with a pre-existing year' do
        test_year
        second_year = build(:year, year: 2016)
        expect(second_year).to_not be_valid
      end
    end

    describe '#previous_year' do
      context 'previous year exists and' do
        it 'should return the previous year' do
          test_year
          next_year = build(:year, year: 2017)
          prev_year = next_year.previous_year
          expect(prev_year).to eq(test_year)
        end
      end

      context 'previous year does not exist and' do
        it 'should return nothing' do
          test_year
          prev_year = test_year.previous_year
          expect(prev_year).to eq(nil)
        end
      end
    end
  end
end
