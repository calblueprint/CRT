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
#  general              :boolean          default(FALSE)
#
# Indexes
#
#  index_projects_on_general  (general)
#

require 'rails_helper'

RSpec.describe Project, type: :model do
  let(:general_project) { create :project, general: true, name: 'Test General' }

  describe '#create' do
    context 'general project does not exist and' do
      it 'should allow a new general project to be valid' do
        expect(general_project).to be_valid
      end
    end

    context 'general project does exist and' do
      it 'should not allow a new general project to be valid' do
        general_project
        project = build(:project, general: true, name: 'Second General')
        expect(project).to_not be_valid
      end
    end
  end
end
