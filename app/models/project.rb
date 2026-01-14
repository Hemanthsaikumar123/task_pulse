class Project < ApplicationRecord

  belongs_to :team
  has_many :tasks, dependent: :destroy
  has_many :activity_logs, as: :trackable


  validates :name, presence: true

  after_create do
    ActivityLog.create(
      user: team.owner,
      action: "created_project",
      trackable: self
    )
  end




  def overdue_tasks
    tasks.select(&:overdue?)
  end

  def health_score
    total = tasks.count
    return 100 if total == 0

    overdue = overdue_tasks.count
    completed = tasks.where(status: "done").count
    in_progress = tasks.where(status: "in_progress").count

    # Similar calculation as team health score
    completion_score = (completed.to_f / total) * 100
    overdue_penalty = (overdue.to_f / total) * 50
    progress_bonus = (in_progress.to_f / total) * 50  # 50% credit for work in progress

    score = completion_score + progress_bonus - overdue_penalty
    
    # Ensure score is between 0 and 100
    [[score.round, 0].max, 100].min
  end

end
