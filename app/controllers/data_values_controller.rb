class DataValuesController < ApplicationController
  def destroy
    DataValue.destroy params[:id]
  end

  private
    def data_value_params
      params.require(:data_value).permit(:value, :data_type_id)
    end
end
