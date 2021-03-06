class AccessTokensController < ApplicationController
  before_filter :authenticate_user!

  def redirect
    puts "Recieved code #{params[:code]}"
    post_params = {'client_id' => '5723', 'client_secret' => APP_CONFIG["stack_api"]["secret"], 'code' => params[:code], 'redirect_uri' => 'http://wildfire.erwaysoftware.com/access_tokens/redirect'}

    token_request = Net::HTTP.post_form(URI.parse("https://stackexchange.com/oauth/access_token"), post_params)
    begin
      token = token_request.body.scan(/access_token=(.*)$/)[0][0]
      current_user.access_token = token
      current_user.save!
      current_user.check_access_token
      redirect_to flags_path
    rescue => exception
      render :text => "Something went wrong: #{exception.backtrace}" and return
    end
  end

  def begin
  end
end
