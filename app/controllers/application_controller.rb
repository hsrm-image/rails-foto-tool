class ApplicationController < ActionController::Base
	before_action :configure_permitted_parameters, if: :devise_controller?
	prepend_before_action  :set_locale

	def set_locale
		I18n.locale = params[:locale] || extract_locale_from_accept_language_header || I18n.default_locale
	end

	def self.default_url_options(options={})
		options.merge({ :locale => I18n.locale })
	end

	protected

	def configure_permitted_parameters
		devise_parameter_sanitizer.permit(:sign_up, keys: [:name])
	end

	def extract_locale_from_accept_language_header
		unless request.env['HTTP_ACCEPT_LANGUAGE'].nil?
			request.env['HTTP_ACCEPT_LANGUAGE']&.scan(/^[a-z]{2}/)&.first
		end
	end
end
