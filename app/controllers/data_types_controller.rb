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
#  master     :boolean
#

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

    if @data_type.save
      if @data_type.master?
        Project.master_project.create_data_type(@data_type)
      else
        Project.create_data_type_for_specific_projects(@data_type)
      end
    end

    redirect_to action: "index"
  end

  def update
    @data_type = DataType.find(params[:id])
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
      render 'edit'
    end
  end

  def destroy
    DataType.destroy params[:id]

    redirect_to action: "index"
  end


  private
  def data_type_params
    params.require(:data_type).permit(:name, :formula, :master)
  end
end
