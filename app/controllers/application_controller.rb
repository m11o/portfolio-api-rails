# frozen_string_literal: true

class ApplicationController < ActionController::API
  before_action :verify_token

  private

  def verify_token
    ActionController::HttpAuthentication::Token.authenticate(self) do |token|
      ActiveSupport::SecurityUtils.secure_compare(token, ENV.fetch('API_TOKEN'))
    end || head(:unauthorized)
  end
end
