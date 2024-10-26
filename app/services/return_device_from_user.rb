class ReturnDeviceFromUser
  def initialize(user:, serial_number:, from_user:)
    @user = user
    @serial_number = serial_number
    @from_user = from_user
  end

  def call
    validate_return!

    assignment = device.current_assignment
    assignment.update!(
      status: :returned,
      returned_at: Time.current
    )
  end

  private

  def device
    @device ||= Device.find_by!(serial_number: @serial_number)
  end

  def validate_return!
    unless @user.id == @from_user
      raise ReturnError::Unauthorized, I18n.t('errors.only_assigned_user_can_return')
    end

    unless device.assigned_to?(@user)
      raise ReturnError::NotAssigned, I18n.t('errors.device_not_assigned_to_user')
    end
  end
end