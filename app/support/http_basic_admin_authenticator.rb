# frozen_string_literal: true
module HttpBasicAdminAuthenticator
  module_function

  def authenticate_admin
    authenticate_or_request_with_http_basic do |raw_email, password|
      email = raw_email&.strip&.downcase
      @authenticated_admin = User.admins.
        find_by_credentials(email_or_phone: email, password: password)
    end
  end

  def authenticated_admin_user
    @authenticated_admin
  end
end
