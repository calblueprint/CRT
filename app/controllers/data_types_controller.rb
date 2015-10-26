class DataTypesController < ApplicationController
  def index
    @data_types = DataType.all
  end

  def new
    @data_types = DataType.all
    @data_type = DataType.new
  end

  def edit
    @data_types = DataType.all
    @data_type = DataType.find(params[:id])
  end

  def create
    @data_type = DataType.new(data_type_params)
    @years = Year.all
    @data_type.save

    @years.each do |year|
      @data_value = DataValue.new(value: 0.0, year: year, data_type: @data_type)
      @data_value.save
    end

    redirect_to action: "index"
  end

  def update
    @data_type = DataType.find(params[:id])

    if @data_type.update(data_type_params)
      redirect_to action: "index"
    else
      render 'edit'
    end
  end

  def destroy
    DataType.destroy params[:id]
    
    redirect_to action: "index"
  end


  private
  def data_type_params
    params.require(:data_type).permit(:name, :formula)
  end
end
