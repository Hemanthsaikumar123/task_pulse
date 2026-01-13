class ProjectsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_team

  def new
    @project = @team.projects.new
  end

  def create
    @project = @team.projects.new(project_params)
    if @project.save
      redirect_to team_path(@team), notice: "Project created"
    else
      render :new
    end
  end

  def show
    @project = @team.projects.find(params[:id])
    @tasks = @project.tasks
  end

  private

  def set_team
    @team = current_user.teams.find(params[:team_id])
  end

  def project_params
    params.require(:project).permit(:name, :status)
  end
end
