class HomeController < ApplicationController
  def index
    # @account = HelloSign.get_account
  end

  def callback
    render :text => 'Hello API Event Received'
  end
end
