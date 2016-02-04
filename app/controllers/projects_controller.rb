# == Schema Information
#
# Table name: projects
#
#  id                   :integer          not null, primary key
#  name                 :string
#  acres                :integer
#  date_closed          :date
#  restricted_endowment :decimal(, )
#  cap_rate             :decimal(, )
#  admin_rate           :decimal(, )
#  total_upfront        :decimal(, )
#  years_upfront        :integer
#  earnings_begin       :date
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  general              :boolean          default(FALSE)
#
# Indexes
#
#  index_projects_on_general  (general)
#

require 'tsort'

# Topological sorting hash
class TsortableHash < Hash
  include TSort
  alias tsort_each_node each_key
  def tsort_each_child(node, &block)
    fetch(node).each(&block)
  end
end

class ProjectsController < ApplicationController
  def index
    @projects = Project.all
  end

  # TODO (kevin): Transfer to service object
  def show
    @project = Project.find(params[:id])
    @data_types = DataType.all
    @data_values = DataValue.all

    # Find dependencies of each data value
    data_values = TsortableHash[]
    @data_values.each do |data_value|
      # Only calculate data values in this project
      next unless @project.project_years.find_by_id(data_value.project_year_id) # TODO: Refactor.
      formula = @data_types.find(data_value.data_type_id).formula
      if formula
        year = data_value.project_year_id
        dependencies = []
        @data_types.each do |data_type|
          if formula.include? derscore(data_type.name)
            dependencies.push(@data_values.find_by(project_year_id: year, data_type: data_type))
          end
        end
        data_values[data_value] = dependencies
      else
        data_values[data_value] = []
      end
    end

    # Calculate data values in topological order
    data_values.tsort.each do |data_value|
      formula = @data_types.find(data_value.data_type_id).formula
      if formula
        # Initialize calculator and year
        calculator = Dentaku::Calculator.new
        year = data_value.project_year_id
        @data_types.each do |data_type|
          if formula.include? derscore(data_type.name)
            name = derscore(data_type.name)
            value = @data_values.find_by(project_year: year, data_type: data_type).value
            calculator.store(name => value)
          end
        end
        # Evaluate formula and save
        data_value.value = calculator.evaluate(formula)
        data_value.save
      end
    end
  end

  def derscore(string)
    return string.split(' ').join('_')
  end

  def new
    @project = Project.new
  end

  def edit
    @project = Project.find(params[:id])
  end

  def create
    @project = Project.new(project_params)

    if @project.save
      redirect_to @project
    else
      render 'new'
    end
  end

  def update
    @project = Project.find(params[:id])

    if @project.update(project_params)
      redirect_to @project
    else
      render 'edit'
    end
  end

  def destroy
    Project.destroy params[:id]

    redirect_to projects_path
  end

  private

  def project_params
    params.require(:project).permit(
      :name, :acres, :date_closed,
      :restricted_endowment, :cap_rate, :admin_rate, :total_upfront,
      :years_upfront, :earnings_begin
    )
  end
end
