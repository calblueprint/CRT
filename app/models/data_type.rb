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
#

class DataType < ActiveRecord::Base
  has_many :data_values, dependent: :destroy

  validates :name, presence: true, uniqueness: {
    scope: :master,
    message: "#{name} already exists."
  }
  validates :order, presence: { message: "must have order." },
                    numericality: {
                      greater_than: 0,
                      message: "invalid order."
                    }, on: [:update]

  def has_formula?
    formula.blank?
  end
end
