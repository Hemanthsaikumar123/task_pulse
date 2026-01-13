class Task < ApplicationRecord
  before_update :set_completed_at

  def set_completed_at
    if status_changed? && status == "done"
      self.completed_at = Time.current
    end
  end


  after_update :log_status_change

  def log_status_change
    if saved_change_to_status?
      ActivityLog.create(
        user: assignee,
        action: "task_#{status}",
        trackable: self
      )
    end
  end


  belongs_to :project
  belongs_to :assignee, class_name: "User"

  has_many :comments, dependent: :destroy
  has_many :activity_logs, as: :trackable


  validates :title, presence: true
  validates :status, inclusion: { in: %w[todo in_progress done] }



  def overdue?
    due_date.present? && due_date < Date.today && status != "done"
  end

  def in_progress?
    status == "in_progress"
  end

  def completed?
    status == "done"
  end


end
