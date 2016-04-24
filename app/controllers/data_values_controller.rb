# == Schema Information
#
# Table name: data_values
#
#  id              :integer          not null, primary key
#  type            :integer
#  value           :decimal(19, 4)
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  data_type_id    :integer          not null
#  project_year_id :integer          not null
#  formula_value   :decimal(19, 4)
#  input_formula   :string
#  input_type      :integer          default(0)
#
# Indexes
#
#  index_data_values_on_data_type_id  (data_type_id)
#

class DataValuesController < ApplicationController
  def destroy
    DataValue.destroy params[:id]
  end

  def update
    @data_value = DataValue.find(params[:id])
    old_attributes = @data_value.attributes
    begin
      @data_value.update(parse_input_value_params)
      @project = Project.find(@data_value.project)
      @data_types = DataType.where(master: @project.master?).order(:order)
      ParseFormulaService.update_data_values(@project, @data_types)
      render json: @data_value.project.data_values
    rescue ZeroDivisionError
      @data_value.update(old_attributes)
      render json: { errors: 'Cannot divide by zero' }, status: 422
    rescue RuntimeError
      @data_value.update(old_attributes)
      render json: { errors: 'Cannot accept input format' }, status: 422
    rescue TSort::Cyclic
      @data_value.update(old_attributes)
      render json: { errors: 'Cyclic reference detected' }, status: 422
    end
  end

  private

  def data_value_params
    params.require(:data_value).permit(:value, :input_formula, :data_type_id)
  end

  def parse_input_value_params
    input_value_string = params[:data_value][:input_value]
    input_value = Float(input_value_string) rescue input_value_string
    if input_value.is_a? String
      parse_input_value_params = { value: nil, input_formula: input_value }
    else
      parse_input_value_params = { value: input_value, input_formula: nil }
    end
    parse_input_value_params
  end
end
