class ProjectsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_team
  before_action :set_project, only: [:show, :edit, :update, :destroy]

  def new
    @project = @team.projects.new
  end

  def create
    @project = @team.projects.new(project_params)
    if @project.save
      redirect_to team_path(@team), notice: "Project created successfully"
    else
      render :new
    end
  end

  def show
    @tasks = @project.tasks
  end

  def edit
  end

  def update
    if @project.update(project_params)
      redirect_to team_path(@team), notice: "Project updated successfully"
    else
      render :edit
    end
  end

  def destroy
    @project.destroy
    redirect_to team_path(@team), notice: "Project deleted successfully"
  end

  private

  def set_team
    @team = current_user.teams.find(params[:team_id])
  end

  def set_project
    @project = @team.projects.find(params[:id])
  end

  def project_params
    params.require(:project).permit(:name, :status)
  end
end
