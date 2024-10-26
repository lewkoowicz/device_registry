module Api
  module V1
    class SessionsController < ApiController
      skip_before_action :authenticate_user!, :verify_csrf_token, only: [:create]

      def create
        if (user = User.authenticate_by(email: params[:email], password: params[:password]))
          login user
          render json: { user: UserSerializer.new(user) }
        else
          render_error('Invalid email or password', :unauthorized)
        end
      end

      def destroy
        logout
        render json: { message: 'Logged out successfully' }
      end
    end
  end
end