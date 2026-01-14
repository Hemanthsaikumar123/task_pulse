class DashboardController < ApplicationController
  before_action :authenticate_user!

  def index
    @teams = current_user.teams
    @alerts = []
    seen_users = Set.new

    @teams.each do |team|
      overdue_count = team.overdue_tasks.count
      total_tasks = team.all_tasks.count
      
      # Only alert on health if there are actual overdue tasks
      if overdue_count > 0 && team.health_score < 40
        @alerts << "🚨 CRITICAL: Team '#{team.name}' has #{overdue_count} overdue tasks and low health (#{team.health_score}%)"
      elsif overdue_count >= 5
        @alerts << "⏰ Team '#{team.name}' has #{overdue_count} overdue tasks - needs attention"
      elsif overdue_count >= 3
        @alerts << "⚠️ Team '#{team.name}' has #{overdue_count} overdue tasks"
      end

      # Check individual user workload (avoid duplicates for users in multiple teams)
      team.users.each do |user|
        next if seen_users.include?(user.id)
        seen_users.add(user.id)

        overdue = user.overdue_tasks.count
        
        # Only alert on overdue tasks, not just high workload
        if overdue >= 5
          @alerts << "🔥 URGENT: #{user.name} has #{overdue} overdue tasks - immediate action needed"
        elsif overdue >= 3
          @alerts << "⏰ #{user.name} has #{overdue} overdue tasks"
        elsif overdue > 0 && user.workload > 10
          # Only mention workload if there are also overdue tasks
          @alerts << "⚠️ #{user.name} has #{overdue} overdue task#{'s' if overdue > 1} and #{user.workload} active tasks"
        end
      end
    end

    # Sort alerts by severity (🚨 first, then 🔥, then ⏰, then ⚠️)
    @alerts.sort_by! do |alert|
      case alert[0..1]
      when "🚨" then 0
      when "🔥" then 1
      when "⏰" then 2
      when "⚠️" then 3
      else 4
      end
    end

    # Limit alerts to prevent overwhelming the user
    @alerts = @alerts.take(10) if @alerts.count > 10

    # Get recent activities from all user's teams
    team_ids = @teams.pluck(:id)
    @activities = ActivityLog
      .joins("LEFT JOIN projects ON activity_logs.trackable_type = 'Project' AND activity_logs.trackable_id = projects.id")
      .joins("LEFT JOIN tasks ON activity_logs.trackable_type = 'Task' AND activity_logs.trackable_id = tasks.id")
      .joins("LEFT JOIN projects AS task_projects ON tasks.project_id = task_projects.id")
      .where("projects.team_id IN (?) OR task_projects.team_id IN (?)", team_ids, team_ids)
      .or(ActivityLog.where(user: current_user))
      .includes(:user, :trackable)
      .order(created_at: :desc)
      .limit(20)
  end

end
