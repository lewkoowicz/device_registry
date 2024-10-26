require 'rails_helper'

RSpec.describe ReturnDeviceFromUser do
  subject(:return_device) do
    described_class.new(
      user: user,
      serial_number: device.serial_number,
      from_user: from_user_id
    ).call
  end

  let(:user) { create(:user) }
  let(:other_user) { create(:user) }
  let(:device) { create(:device) }
  let!(:device_assignment) { create(:device_assignment, device: device, user: user, status: :active) }
  let(:from_user_id) { user.id }

  context 'when the user is authorized to return the device' do
    it 'returns the device successfully' do
      expect { return_device }.to change { device_assignment.reload.status }.from('active').to('returned')
    end
  end

  context 'when the user is not authorized to return the device' do
    let(:from_user_id) { other_user.id }

    it 'raises an Unauthorized error' do
      expect { return_device }.to raise_error(ReturnError::Unauthorized, "Only the assigned user can return a device")
    end
  end

  context 'when the device is not assigned to the user' do
    before do
      device_assignment.update!(status: :returned)
      create(:device_assignment, device: device, user: other_user, status: :active)
    end

    it 'raises a NotAssigned error' do
      expect { return_device }.to raise_error(ReturnError::NotAssigned, "Device is not assigned to this user")
    end
  end
end