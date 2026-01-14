class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_task

  def create
    @comment = @task.comments.new(comment_params)
    @comment.user = current_user

    if @comment.save
      redirect_to team_project_path(@task.project.team, @task.project)
    else
      redirect_to team_project_path(@task.project.team, @task.project), alert: "Comment failed"
    end
  end

  def destroy
    @comment = @task.comments.find(params[:id])
    
    if @comment.user == current_user || @task.project.team.owner == current_user
      @comment.destroy
      redirect_to team_project_path(@task.project.team, @task.project), notice: "Comment deleted"
    else
      redirect_to team_project_path(@task.project.team, @task.project), alert: "You can only delete your own comments"
    end
  end

  private

  def set_task
    @task = Task.find(params[:task_id])
  end

  def comment_params
    params.require(:comment).permit(:content)
  end
end
