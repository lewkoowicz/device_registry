class UserSerializer < ActiveModel::Serializer
  attributes :id, :email
  has_many :active_devices
end