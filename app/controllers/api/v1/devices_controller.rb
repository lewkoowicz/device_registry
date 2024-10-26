module Api
  module V1
    class DevicesController < ApiController
      def assign
        service = AssignDeviceToUser.new(
          requesting_user: current_user,
          serial_number: params[:serial_number],
          new_device_owner_id: current_user.id
        )

        service.call
        render json: { message: I18n.t('errors.device_assigned_successfully') }, status: :ok
      rescue AssigningError::AlreadyUsedOnUser, AssigningError::AlreadyUsedOnOtherUser, RegistrationError::Unauthorized => e
        render_error(e.message, :unprocessable_entity)
      rescue ActiveRecord::RecordNotFound
        render_error(I18n.t('errors.device_not_found'), :not_found)
      rescue StandardError
        render_error(I18n.t('errors.unknown_error'), :internal_server_error)
      end

      def unassign
        service = ReturnDeviceFromUser.new(
          user: current_user,
          serial_number: params[:serial_number],
          from_user: current_user.id
        )

        service.call
        render json: { message: I18n.t('errors.device_unassigned_successfully') }, status: :ok
      rescue ReturnError::Unauthorized, ReturnError::NotAssigned => e
        render_error(e.message, :unprocessable_entity)
      rescue ActiveRecord::RecordNotFound
        render_error(I18n.t('errors.device_not_found'), :not_found)
      rescue StandardError
        render_error(I18n.t('errors.unknown_error'), :internal_server_error)
      end

      private

      def device_params
        params.require(:device).permit(:serial_number)
      end
    end
  end
end