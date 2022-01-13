class ApplicationController < ActionController::Base
	before_action :configure_permitted_parameters, if: :devise_controller?
	around_action :switch_locale

	def switch_locale(&action)
		locale =
			params[:locale] || extract_locale_from_accept_language_header ||
				I18n.default_locale
		I18n.with_locale(locale, &action)
	end

	def default_url_options
		{ locale: I18n.locale }
	end

	protected

	def configure_permitted_parameters
		devise_parameter_sanitizer.permit(:sign_up, keys: [:name])
	end

	def extract_locale_from_accept_language_header
		request.env['HTTP_ACCEPT_LANGUAGE'].scan(/^[a-z]{2}/).first
	end
end
