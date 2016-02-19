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
#  master     :boolean
#

class DataType < ActiveRecord::Base
  has_many :data_values, dependent: :destroy

  validates :name, presence: true, uniqueness: true
  validates :order, presence: true
  validates :order,
            numericality: {
              greater_than: 0,
              less_than_or_equal_to: DataType.count
            }, on: [:update]
end
