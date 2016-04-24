# == Schema Information
#
# Table name: project_years
#
#  id         :integer          not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  project_id :integer          not null
#  year_id    :integer          not null
#  date       :integer
#
# Indexes
#
#  index_project_years_on_project_id  (project_id)
#

require 'rails_helper'

RSpec.describe ProjectYear, type: :model do
  let(:project) { create :project, name: 'Project',
                                   acres: 20,
                                   date_closed: '2012-01-01',
                                   restricted_endowment: 52.5,
                                   cap_rate: 34.50,
                                   admin_rate: 3.50,
                                   total_upfront: 100,
                                   years_upfront: 10,
                                   earnings_begin: '2014-01-01',
                                   master: false }
  let(:year1) { create :year, year: 2013 }
  let(:year2) { create :year, year: 2014 }
  let(:year3) { create :year, year: 2015 }
  let(:project_year1) { create :project_year, date: 2013, project: project, year: year1 }
  let(:project_year2) { create :project_year, date: 2014, project: project, year: year2 }
  let(:project_year3) { create :project_year, date: 2015, project: project, year: year3 }
  let(:datatype) { create :data_type, name: 'Data Type', order: '2' }
  let(:datatype1) { create :data_type, name: 'Data Type 1', order: 1 }
  let(:datatype2) { create :data_type, name: 'Data Type 2', order: 1 }
  let(:datavalue1) { create :data_value, data_type: datatype1, project_year: project_year1 }
  let(:datavalue2) { create :data_value, data_type: datatype2, project_year: project_year1 }

  describe '#create' do
    # create_data_value_for_data_type
    it 'should create data value for correct data type' do
      expect(project_year1.create_data_value_for_data_type(datatype)).to be_valid
    end

    # previous_project_year
    it 'should get correct previous project year' do
      expect(project_year1).to eq(project_year2.previous_project_year)
      expect(project_year2).to eq(project_year3.previous_project_year)
    end

    # sorted_data_values
    it 'should correctly sort data values' do
      expect(project_year1.sorted_data_values).to be_truthy
      expect(project_year2.sorted_data_values).to be_truthy
      expect(project_year3.sorted_data_values).to be_truthy
    end

    # associate_year
    it 'should correctly associate year' do
      expect(project_year1.associate_year).to eq(true)
      expect(project_year2.associate_year).to eq(true)
      expect(project_year3.associate_year).to eq(true)
    end

    # create_data_values_on_project_year_create
    it 'should correctly initialize data values on project year create' do
      expect(project_year1.create_data_values_on_project_year_create).to be_truthy
      expect(project_year2.create_data_values_on_project_year_create).to be_truthy
      expect(project_year3.create_data_values_on_project_year_create).to be_truthy
    end
  end
end
