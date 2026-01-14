class Team < ApplicationRecord
  belongs_to :owner, class_name: "User"

  has_many :team_memberships
  has_many :users, through: :team_memberships
  has_many :projects, dependent: :destroy

  after_create :add_owner_to_team

  def add_owner_to_team
    team_memberships.create(user: owner, role: "admin")
  end



  def all_tasks
    projects.includes(:tasks).flat_map(&:tasks)
  end

  def overdue_tasks
    all_tasks.select(&:overdue?)
  end

  def completion_rate
    total = all_tasks.count
    return 0 if total == 0

    done = all_tasks.count { |t| t.status == "done" }
    ((done.to_f / total) * 100).round
  end

  def health_score
    total = all_tasks.count
    return 100 if total == 0

    overdue = overdue_tasks.count
    done = all_tasks.count { |t| t.status == "done" }
    in_progress = all_tasks.count { |t| t.status == "in_progress" }

    # Calculate base score: completed tasks contribute positively
    # Overdue tasks penalize heavily, in-progress tasks contribute 50%
    completion_score = (done.to_f / total) * 100
    overdue_penalty = (overdue.to_f / total) * 50  # 50% penalty per overdue task
    progress_bonus = (in_progress.to_f / total) * 50  # 50% credit for work in progress

    score = completion_score + progress_bonus - overdue_penalty
    
    # Ensure score is between 0 and 100
    [[score.round, 0].max, 100].min
  end


end
