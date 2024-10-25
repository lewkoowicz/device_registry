class AssignDeviceToUser
  def initialize(requesting_user:, serial_number:, new_device_owner_id:)
    @requesting_user = requesting_user
    @serial_number = serial_number
    @new_device_owner_id = new_device_owner_id
  end

  def call
    validate_assignment!

    ActiveRecord::Base.transaction do
      device = Device.find_or_create_by!(serial_number: @serial_number)

      DeviceAssignment.create!(
        device: device,
        user: @requesting_user,
        status: :active,
        assigned_at: Time.current
      )
    end
  end

  private

  def validate_assignment!
    unless @requesting_user.id == @new_device_owner_id
      raise RegistrationError::Unauthorized, "Users can only assign devices to themselves"
    end

    device = Device.find_by(serial_number: @serial_number)
    return unless device

    if device.current_assignment.present?
      if device.assigned_to?(@requesting_user)
        raise AssigningError::AlreadyUsedOnUser, "Device is currently assigned to you"
      else
        raise AssigningError::AlreadyUsedOnOtherUser, "Device is currently assigned to another user"
      end
    end

    if DeviceAssignment.exists?(device: device, user: @requesting_user)
      raise AssigningError::AlreadyUsedOnUser, "Device was previously assigned to you"
    end
  end
end