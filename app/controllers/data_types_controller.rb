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
    projects = Project.all

    projects.each do |project|
      if project.name.general
        if @data_type.general?
          years = project.years
          years.each do |year|
            DataValue.create(value: 0.0, year: year, data_type: @data_type)
          end
          break
        end
      else
        unless @data_type.general?
          years = project.years
          years.each do |year|
            DataValue.create(value: 0.0, year: year, data_type: @data_type)
          end
        end
      end
      @data_type.save
    end

    redirect_to action: "index"
  end

  def update
    @data_type = DataType.find(params[:id])
    if @data_type.update(data_type_params)
      # find all data_values linked to changed data_type
      @data_values = DataValue.where(data_type: @data_type)
      # This if statement covers changing data_type from non-general to general
      if @data_type.general?
        @data_values.each do |data_value|
          unless data_value.year.project.general
            # delete all data values not corresponding to years that belong to general project
            DataValue.destroy(data_value.id)
          end
        end
        # add data_values to years that belong to general project
        years = Project.general_project.years
        years.each do |year|
          DataValue.create(value: 0.0, year: year, data_type: @data_type)
        end
      else
        # delete all data values because we are changing from general to non-general
        @data_values.destroy_all
        # add data_type/data_value to each year that doesnt belong to general project
        years = Year.all
        years.reject { |year| year.project.general }.each do |year|
          DataValue.create(value: 0.0, year: year, data_type: @data_type)
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
    params.require(:data_type).permit(:name, :formula, :general)
  end
end
