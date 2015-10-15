class DataTypesController < ApplicationController
  def index
    @data_types = DataType.all
  end

  def new
    @data_type = DataType.new
  end

  def create
    @data_type = DataType.new(data_type_params)

    @data_type.save
    redirect_to action:"index"
  end

  private
  def data_type_params
    params.require(:data_type).permit(:name, :formula)
  end
end
