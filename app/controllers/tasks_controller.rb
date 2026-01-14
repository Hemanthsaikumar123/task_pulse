class TasksController < ApplicationController
  before_action :authenticate_user!
  before_action :set_project
  before_action :set_task, only: [:edit, :update, :destroy]
  
  def new
    @task = @project.tasks.new
    @users = @project.team.users
  end

  def create
    @task = @project.tasks.new(task_params)
    if @task.save
      redirect_to team_project_path(@project.team, @project), notice: "Task created successfully"
    else
      @users = @project.team.users
      render :new
    end
  end

  def edit
    @users = @project.team.users
  end

  def update
    if @task.update(task_params)
      redirect_to team_project_path(@project.team, @project), notice: "Task updated successfully"
    else
      @users = @project.team.users
      render :edit
    end
  end

  def destroy
    @task.destroy
    redirect_to team_project_path(@project.team, @project), notice: "Task deleted successfully"
  end

  private

  def set_project
    @project = Project.find(params[:project_id])
  end

  def set_task
    @task = @project.tasks.find(params[:id])
  end

  def task_params
    params.require(:task).permit(:title, :description, :status, :priority, :due_date, :assignee_id)
  end
end
