class User < ApplicationRecord
  has_many :device_assignments
  has_many :devices, through: :device_assignments
  has_secure_password

  validates :email, presence: true
  normalizes :email, with: -> (email) {email.strip.downcase}

  def active_devices
    devices.merge(DeviceAssignment.active)
  end
end