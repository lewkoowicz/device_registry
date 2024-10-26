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
      raise RegistrationError::Unauthorized, I18n.t('errors.users_can_only_assign_to_themselves')
    end

    device = Device.find_by(serial_number: @serial_number)
    return unless device

    if device.current_assignment.present?
      if device.assigned_to?(@requesting_user)
        raise AssigningError::AlreadyUsedOnUser, I18n.t('errors.device_currently_assigned_to_you')
      else
        raise AssigningError::AlreadyUsedOnOtherUser, I18n.t('errors.device_currently_assigned_to_another')
      end
    end

    if DeviceAssignment.exists?(device: device, user: @requesting_user)
      raise AssigningError::AlreadyUsedOnUser, I18n.t('errors.device_previously_assigned_to_you')
    end
  end
end