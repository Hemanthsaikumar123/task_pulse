class TeamsController < ApplicationController
  before_action :authenticate_user!
  def add_member
    @team = current_user.owned_teams.find(params[:id])

    user = User.find_by(email: params[:email])

    if user
      @team.team_memberships.find_or_create_by(user: user, role: "member")
      redirect_to team_path(@team), notice: "User added to team"
    else
      redirect_to team_path(@team), alert: "User not found. Ask them to sign up."
    end
  end

  def remove_member
    @team = current_user.owned_teams.find(params[:id])
    user = User.find(params[:user_id])
    membership = @team.team_memberships.find_by(user: user)

    if membership && user != @team.owner
      membership.destroy
      redirect_to team_path(@team), notice: "#{user.name} removed from team"
    else
      redirect_to team_path(@team), alert: "Cannot remove team owner or member not found"
    end
  end


  def index
    @teams = current_user.teams
  end

  def new
    @team = Team.new
  end

  def create
    @team = Team.new(team_params)
    @team.owner = current_user

    if @team.save
      redirect_to teams_path, notice: "Team created successfully"
    else
      render :new
    end
  end

  def show
    @team = Team.find(params[:id])
    @projects = @team.projects
    @members = @team.team_memberships.includes(:user)
  end


  private

  def team_params
    params.require(:team).permit(:name)
  end
end
