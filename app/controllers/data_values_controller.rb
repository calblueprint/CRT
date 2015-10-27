class DataValuesController < ApplicationController
  def create
    @data_value = DataValue.new(data_value_params)
    @data_types = DataType.all

    if @data_value.save
      @data_types.find(@data_value.data_type_id) << @data_value
      redirect_to @data_value.year.project
    else
      render 'new'
    end
  end

  private
    def data_value_params
      params.require(:data_value).permit(:value, :data_type_id)
    end
end
