# == Schema Information
#
# Table name: data_values
#
#  id           :integer          not null, primary key
#  type         :integer
#  value        :decimal(, )
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  year_id      :integer          not null
#  data_type_id :integer          not null

class DataValue < ActiveRecord::Base
  belongs_to :year, :data_type
end
