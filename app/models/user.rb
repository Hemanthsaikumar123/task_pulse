class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_many :owned_teams, class_name: "Team", foreign_key: "owner_id"
  has_many :team_memberships
  has_many :teams, through: :team_memberships
  has_many :assigned_tasks, class_name: "Task", foreign_key: "assignee_id"
  has_many :comments

  def active_tasks
    assigned_tasks.where.not(status: "done")
  end

  def overdue_tasks
    active_tasks.select(&:overdue?)
  end

  def workload
    active_tasks.count
  end


end
