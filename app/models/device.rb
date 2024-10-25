class Device < ApplicationRecord
  has_many :device_assignments
  has_many :users, through: :device_assignments

  validates :serial_number, presence: true, uniqueness: true

  def current_assignment
    device_assignments.active.first
  end

  def assigned_to?(user)
    device_assignments.active.exists?(user: user)
  end

  def ever_assigned_to?(user)
    device_assignments.exists?(user: user)
  end
end