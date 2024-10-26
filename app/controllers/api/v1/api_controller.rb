module Api
  module V1
    class ApiController < ApplicationController
      protect_from_forgery with: :exception
      before_action :verify_csrf_token

      before_action :authenticate_user!

      private

      def verify_csrf_token
        if request.headers['X-CSRF-Token'].present?
          unless valid_authenticity_token?(session, request.headers['X-CSRF-Token'])
            render_error(I18n.t('errors.invalid_csrf_token'), :unauthorized)
          end
        else
          render_error(I18n.t('errors.missing_csrf_token'), :unauthorized)
        end
      end

      def render_error(message, status)
        render json: { error: message }, status: status
      end
    end
  end
end