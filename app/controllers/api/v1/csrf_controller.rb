module Api
  module V1
    class CsrfController < ApiController
      skip_before_action :authenticate_user!, :verify_csrf_token

      def show
        render json: { csrf_token: form_authenticity_token }
      end
    end
  end
end