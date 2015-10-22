class DataTypesController < ApplicationController
  def index
    @data_types = DataType.all
  end

  def new
    @data_type = DataType.new
  end

  def edit
    @data_type = DataType.find(params[:id])
  end

  def create
    @data_type = DataType.new(data_type_params)

    @data_type.save
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
    @data_type = DataType.find(params[:id])
    @data_type.destroy
    redirect_to action: "index"
  end


  private
  def data_type_params
    params.require(:data_type).permit(:name, :formula)
  end
end
