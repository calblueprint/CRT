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
#  master               :boolean          default(FALSE)
#
# Indexes
#
#  index_projects_on_master  (master)
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

    # Export all projects to CSV
    respond_to do |format|
      format.html
      format.csv { send_data Project.to_csv(@projects) }
    end
  end

  def show
    @project = Project.find(params[:id])
    @data_types = DataType.where(master: @project.master?).order(:order)
    @data_values = DataValue.all
    ParseFormulaService.update_data_values(@project, @data_types, @data_values)

    # Export individual project to CSV
    respond_to do |format|
      format.html
      format.csv { send_data Project.to_csv([@project]), filename: @project.name + ".csv" }
    end
  end

  def new
    @project = Project.new
  end

  def edit
    @project = Project.find(params[:id])
    @project_years = @project.project_years
    @data_types = DataType.all
  end

  def create
    @project = Project.new(project_params)
    @data_types = DataType.all
    if @project.save
      years = @project.earnings_begin.year..Time.now.year
      years.each do |year|
        project_year = ProjectYear.new(date: year, project: @project)
        project_year.associate_year
        project_year.create_data_values_on_project_year_create
        project_year.save
      end
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
      redirect_to 'show'
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
