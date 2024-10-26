module Api
  module V1
    class ApiController < ApplicationController
      protect_from_forgery with: :exception
      before_action :verify_csrf_token

      before_action :authenticate_user!

      private

      def verify_csrf_token
        if request.headers['X-CSRF-Token'].present?
          verify_authenticity_token
        else
          render_error('Invalid CSRF token', :unauthorized)
        end
      end

      def render_error(message, status)
        render json: { error: message }, status: status
      end
    end
  end
end