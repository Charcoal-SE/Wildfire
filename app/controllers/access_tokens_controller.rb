class AccessTokensController < ApplicationController
  def redirect
    puts "Recieved code #{params[:code]}"
  end

  def begin
  end

  def success
  end
end
