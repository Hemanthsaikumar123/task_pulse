class ActivityLog < ApplicationRecord
  belongs_to :user
  belongs_to :trackable, polymorphic: true

  def description
    case action
    when "created_project"
      "created project"
    when "task_todo"
      "marked task as To Do"
    when "task_in_progress"
      "started working on task"
    when "task_done"
      "completed task"
    else
      action.humanize.downcase
    end
  end

  def icon
    case action
    when "created_project"
      "📁"
    when "task_todo"
      "📝"
    when "task_in_progress"
      "🔄"
    when "task_done"
      "✅"
    else
      "📌"
    end
  end

end
