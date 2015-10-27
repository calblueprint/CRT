class DataValuesController < ApplicationController
  private
    def data_value_params
      params.require(:data_value).permit(:value, :data_type_id)
    end
end
