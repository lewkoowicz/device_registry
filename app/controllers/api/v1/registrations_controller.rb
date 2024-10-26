module Api
  module V1
    class RegistrationsController < ApiController
      skip_before_action :authenticate_user!, :verify_csrf_token, only: [:create]

      def create
        @user = User.new(registration_params)
        if @user.save
          login @user
          render json: @user, status: :created
        else
          render_error(@user.errors.full_messages, :unprocessable_entity)
        end
      end

      private

      def registration_params
        params.require(:user).permit(:email, :password, :password_confirmation)
      end
    end
  end
end