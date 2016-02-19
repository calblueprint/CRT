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

class DataTypesController < ApplicationController
  def index
    @data_types = DataType.order(:order)
  end

  def new
    @data_types = DataType.order(:order)
    @data_type = DataType.new
  end

  def edit
    @data_types = DataType.order(:order)
    @data_type = DataType.find(params[:id])
  end

  def create
    @data_type = DataType.new(data_type_params)
    @data_type.order = DataType.count + 1

    if @data_type.save
      if @data_type.master?
        Project.master_project.create_data_type(@data_type)
      else
        Project.create_data_type_for_specific_projects(@data_type)
      end
      redirect_to action: "index"
    else
      flash[:errors] = @data_type.errors.full_messages.first
      redirect_to action: "new"
    end
  end

  def update
    @data_type = DataType.find(params[:id])

    previous_order = @data_type.order
    new_order = data_type_params[:order].to_i
    if new_order <= DataType.count && new_order > 0
      detect_order_change(previous_order, new_order)
    end
    if @data_type.update(data_type_params)
      # find all data_values linked to changed data_type
      data_values = @data_type.data_values
      # This if statement covers changing data_type from non-master to master
      if @data_type.master?
        data_values.reject(&:master?).map(&:destroy)
        # add data_values to years that belong to master project
        Project.master_project.create_data_type @data_type
      else
        # delete all data values because we are changing from master to non-master
        data_values.destroy_all
        # add data_type/data_value to each year that doesnt belong to master project
        ProjectYear.specific.each do |project_year|
          project_year.create_data_value_for_data_type @data_type
        end
      end
      redirect_to action: "index"
    else
      flash[:errors] = @data_type.errors.full_messages.first
      redirect_to action: "edit"
    end
  end

  def destroy
    deleted_data_type_order = DataType.find(params[:id]).order
    @data_types = DataType.order(:order)
    DataType.transaction do
      DataType.destroy params[:id]
      @data_types.each do |data_type|
        if data_type.order > deleted_data_type_order
          data_type.order = data_type.order - 1
          fail data_type.errors.to_full_messages unless data_type.save
        end
      end
    end


    redirect_to action: "index"
  end

  private

  def data_type_params
    params.require(:data_type).permit(:name, :formula, :order, :master)
  end

  # rearrange order number of the corresponding data types.
  def detect_order_change(previous_order, new_order)
    if previous_order != new_order
      data_type_to_update = DataType.find_by(order: new_order)
      data_type_to_update.order = previous_order
      data_type_to_update.save
    end
  end
end
