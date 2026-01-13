class TeamMembership < ApplicationRecord
  belongs_to :user
  belongs_to :team

  validates :role, presence: true

end
