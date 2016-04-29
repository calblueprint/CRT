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
#  notes                :text
#
# Indexes
#
#  index_projects_on_master  (master)
#

class ProjectsController < ApplicationController
  def index
    @projects = if params[:search]
                  Project.search(params[:search])
                else
                  Project.all
                end
    @projects = @projects.where(master: true) +
                @projects.where(master: false).order(:name)
    # Export all projects to CSV
    respond_to do |format|
      format.html
      format.csv { send_data Project.to_csv(@projects) }
    end
  end

  def show
    @project = Project.includes(:project_years).find(params[:id])
    @data_types = DataType.includes(:data_values).where(master: @project.master?).order(:order)
    ParseFormulaService.update_data_values(@project, @data_types)

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
    if @project.save
      @project.initialize_project_years_and_data_values
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

  def import
    file = params[:file]
    begin
      project = ImportSheetService.create_project(file) if file
      flash[:success] = "#{project.name} successfully imported!"
      redirect_to projects_path
    rescue
      flash[:alert] = "Problem importing project. Please make sure file is correct format."
      redirect_to projects_path
    end
  end

  private

  def project_params
    params.require(:project).permit(
      :name, :acres, :date_closed,
      :restricted_endowment, :cap_rate, :admin_rate, :total_upfront,
      :years_upfront, :earnings_begin, :notes
    )
  end
end
