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

    score = ((done.to_f - overdue) / total) * 100
    score.round
  end


end
