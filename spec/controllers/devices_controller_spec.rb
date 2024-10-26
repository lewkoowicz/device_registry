require 'rails_helper'

RSpec.describe Api::V1::DevicesController, type: :controller do
  let(:user) { create(:user) }

  describe 'POST #assign' do
    subject(:assign_request) do
      request.headers['X-CSRF-Token'] = 'valid-csrf-token'
      post :assign, params: { serial_number: '123456' }
    end

    context 'when the user is authenticated' do
      before do
        allow(controller).to receive(:current_user).and_return(user)
        allow(controller).to receive(:verify_authenticity_token).and_return(true)
      end

      it 'returns a success response' do
        allow_any_instance_of(AssignDeviceToUser).to receive(:call)
        assign_request
        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)).to eq({ 'message' => 'Device assigned successfully' })
      end

      context 'when the device is already assigned to the user' do
        it 'returns an unprocessable entity response' do
          allow_any_instance_of(AssignDeviceToUser).to receive(:call).and_raise(AssigningError::AlreadyUsedOnUser)
          assign_request
          expect(response).to have_http_status(422)
        end
      end

      context 'when the device is assigned to another user' do
        it 'returns an unprocessable entity response' do
          allow_any_instance_of(AssignDeviceToUser).to receive(:call).and_raise(AssigningError::AlreadyUsedOnOtherUser)
          assign_request
          expect(response).to have_http_status(422)
        end
      end

      context 'when the device is not found' do
        it 'returns a not found response' do
          allow_any_instance_of(AssignDeviceToUser).to receive(:call).and_raise(ActiveRecord::RecordNotFound)
          assign_request
          expect(response).to have_http_status(:not_found)
          expect(JSON.parse(response.body)).to eq({ 'error' => 'Device not found' })
        end
      end
    end

    context 'when the user is not authenticated' do
      before do
        allow(controller).to receive(:verify_authenticity_token).and_return(true)
      end

      it 'returns an unauthorized response' do
        assign_request
        expect(response).to have_http_status(:unauthorized)
        expect(JSON.parse(response.body)).to eq({ 'error' => 'Unauthorized' })
      end
    end

    context 'when CSRF token is invalid' do
      before do
        allow(controller).to receive(:verify_authenticity_token).and_raise(ActionController::InvalidAuthenticityToken)
      end

      it 'returns an unauthorized response' do
        expect { assign_request }.to raise_error(ActionController::InvalidAuthenticityToken)
      end
    end
  end

  describe 'POST #unassign' do
    subject(:unassign_request) do
      request.headers['X-CSRF-Token'] = 'valid-csrf-token'
      post :unassign, params: { serial_number: '123456' }
    end

    context 'when the user is authenticated' do
      before do
        allow(controller).to receive(:current_user).and_return(user)
        allow(controller).to receive(:verify_authenticity_token).and_return(true)
      end

      it 'returns a success response' do
        allow_any_instance_of(ReturnDeviceFromUser).to receive(:call)
        unassign_request
        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)).to eq({ 'message' => 'Device unassigned successfully' })
      end

      context 'when the user is not authorized to unassign the device' do
        it 'returns an unprocessable entity response' do
          allow_any_instance_of(ReturnDeviceFromUser).to receive(:call).and_raise(ReturnError::Unauthorized)
          unassign_request
          expect(response).to have_http_status(422)
        end
      end

      context 'when the device is not assigned to the user' do
        it 'returns an unprocessable entity response' do
          allow_any_instance_of(ReturnDeviceFromUser).to receive(:call).and_raise(ReturnError::NotAssigned)
          unassign_request
          expect(response).to have_http_status(422)
        end
      end

      context 'when the device is not found' do
        it 'returns a not found response' do
          allow_any_instance_of(ReturnDeviceFromUser).to receive(:call).and_raise(ActiveRecord::RecordNotFound)
          unassign_request
          expect(response).to have_http_status(:not_found)
          expect(JSON.parse(response.body)).to eq({ 'error' => 'Device not found' })
        end
      end
    end

    context 'when the user is not authenticated' do
      before do
        allow(controller).to receive(:verify_authenticity_token).and_return(true)
      end

      it 'returns an unauthorized response' do
        unassign_request
        expect(response).to have_http_status(:unauthorized)
        expect(JSON.parse(response.body)).to eq({ 'error' => 'Unauthorized' })
      end
    end

    context 'when CSRF token is invalid' do
      before do
        allow(controller).to receive(:verify_authenticity_token).and_raise(ActionController::InvalidAuthenticityToken)
      end

      it 'returns an unauthorized response' do
        expect { unassign_request }.to raise_error(ActionController::InvalidAuthenticityToken)
      end
    end
  end
end