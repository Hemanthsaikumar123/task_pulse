class DashboardController < ApplicationController
  before_action :authenticate_user!

  def index
    @teams = current_user.teams
    @alerts = []

    @teams.each do |team|
      if team.health_score < 60
        @alerts << "🚨 Team #{team.name} is unhealthy (#{team.health_score}%)"
      end

      team.users.each do |user|
        if user.workload > 7
          @alerts << "⚠️ #{user.name} is overloaded (#{user.workload} tasks)"
        end

        if user.overdue_tasks.any?
          @alerts << "⏰ #{user.name} has #{user.overdue_tasks.count} overdue tasks"
        end
      end
    end
  end

end
