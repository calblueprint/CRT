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
#  master               :boolean          default(FALSE)
#
# Indexes
#
#  index_projects_on_master  (master)
#

require 'rails_helper'

RSpec.describe Project, type: :model do
  let(:master_project) { create :project, master: true, name: 'Test Master' }

  describe '#create' do
    context 'master project does not exist and' do
      it 'should allow a new master project to be valid' do
        expect(master_project).to be_valid
      end
    end

    context 'master project does exist and' do
      it 'should not allow a new master project to be valid' do
        master_project
        project = build(:project, master: true, name: 'Second Master')
        expect(project).to_not be_valid
      end
    end
  end
end
