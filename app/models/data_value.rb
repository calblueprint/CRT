# == Schema Information
#
# Table name: data_values
#
#  id              :integer          not null, primary key
#  type            :integer
#  value           :decimal(, )
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  data_type_id    :integer
#  project_year_id :integer
#
# Indexes
#
#  index_data_values_on_data_type_id  (data_type_id)
#
# Foreign Keys
#
#  fk_rails_6d2840a8d9  (data_type_id => data_types.id)
#

class DataValue < ActiveRecord::Base
  belongs_to :project_year
  belongs_to :data_type
  has_one :project, through: :project_year
  has_one :year, through: :project_year

  delegate :general?, to: :project
end
