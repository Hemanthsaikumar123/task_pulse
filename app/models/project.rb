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

    score = ((completed.to_f - overdue) / total) * 100
    score.round
  end

end
