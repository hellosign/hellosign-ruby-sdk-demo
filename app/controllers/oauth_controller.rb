class OauthController < ApplicationController
  def index
    @auth = HelloSign.get_oauth_token(:state => params[:state], :code => params[:code])
    cookies[:access_token] = @auth["access_token"]
  end
end
