# == Schema Information
#
# Table name: project_years
#
#  id         :integer          not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  project_id :integer          not null
#  year_id    :integer          not null
#  date       :integer
#
# Indexes
#
#  index_project_years_on_project_id  (project_id)
#
# Foreign Keys
#
#  fk_rails_e30c6afec7  (project_id => projects.id)
#

class ProjectYearsController < ApplicationController
  def index
    @project_years = ProjectYear.all
  end

  def new
    @project_year = ProjectYear.new
    @project_year.project_id = params[:project_id]
  end

  def create
    @project_year = ProjectYear.new(project_year_params)
    @project_year.associate_year
    @project_year.create_data_values_on_project_year_create
    if @project_year.save
      redirect_to project_path(@project_year.project)
    else
      render 'new'
    end
  end

  private

  def project_year_params
    params.require(:project_year).permit(:date, :project_id)
  end
end
