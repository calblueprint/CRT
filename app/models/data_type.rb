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
  before_validation :set_order
  enum input_type: [:currency, :rate]

  def has_formula?
    formula.blank?
  end

  def set_order
    self.order ||= DataType.where(master: self.master).size + 1
  end
end
