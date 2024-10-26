class DeviceSerializer < ActiveModel::Serializer
  attributes :id, :serial_number, :assigned_at

  def assigned_at
    object.current_assignment&.created_at
  end
end