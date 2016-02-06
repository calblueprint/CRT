class Api::V1::ProjectYearsController < ApplicationController
  def index
    project = Project.find(params[:project_id])
    project_years = project.project_years
    render json: project_years
  end
end
