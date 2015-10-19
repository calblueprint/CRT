
# == Schema Information
#
# Table name: data_types
#
#  id           :integer          not null, primary key
#  formula      :string           not null
#  name         :string           not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null

class DataType < ActiveRecord::Base
end
