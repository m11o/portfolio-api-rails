# frozen_string_literal: true

class ApplicationController < ActionController::API
  before_action :verify_token

  private

  def verify_token
    authenticate_or_request_with_http_token do |token|
      ActiveSupport::SecurityUtils.secure_compare(token, Rails.env.fetch['API_TOKEN'])
    end
  end
end
