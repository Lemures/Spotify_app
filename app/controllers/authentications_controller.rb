class AuthenticationsController < ApplicationController

  def new


  end


  def create

    client_id = 'da2da129ffe848c89a84c58bde46937d'

    #redirect_uri = 'http://0.0.0.0:3000/tracks'

    redirect_uri = session[:last_uri]

    scopes = %w(user-library-read)

    spotify_url = "https://accounts.spotify.com/authorize?client_id=#{client_id}&response_type=code&redirect_uri=#{redirect_uri}&scope=#{URI.escape(scopes.join(' '))}"

    redirect_to spotify_url



  end


end
