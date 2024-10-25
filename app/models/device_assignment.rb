class DeviceAssignment < ApplicationRecord
  belongs_to :device
  belongs_to :user

  validates :status, presence: true

  enum status: { active: 'active', returned: 'returned' }

  scope :active, -> { where(status: 'active') }
end