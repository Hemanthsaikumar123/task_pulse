class TasksController < ApplicationController
  before_action :authenticate_user!
  before_action :set_project
  
  def new
    @task = @project.tasks.new
    @users = @project.team.users
  end

  def create
    @task = @project.tasks.new(task_params)
    if @task.save
      redirect_to team_project_path(@project.team, @project), notice: "Task created"
    else
      render :new
    end
  end

  def update
    @task = @project.tasks.find(params[:id])
    @task.update(task_params)
    redirect_to team_project_path(@project.team, @project)
  end

  private

  def set_project
    @project = Project.find(params[:project_id])
  end

  def task_params
    params.require(:task).permit(:title, :description, :status, :priority, :due_date, :assignee_id)
  end
end
