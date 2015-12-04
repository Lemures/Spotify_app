class TracksController < ApplicationController
  require 'cgi'
  require 'URI'

  def index


  if request.query_string.present?

    @qParams = CGI::parse(URI::parse(request.original_url).query)

    if @qParams['code'][0] == session[:spotify_access_token]

      @user_signed_in = true

      if @qParams['viewSaved']


        requestViewSave = Typhoeus::Request.new("https://api.spotify.com/v1/me/tracks", method: :get, headers: {Authorization: "Bearer #{session[:spotify_access_token]}"} )

        requestViewSave.run

        responseViewSave= requestViewSave.response.body

        jsonRespViewSave = JSON.parse(responseViewSave)

        @rJsonViewSave = jsonRespViewSave['items']



      end


    elsif params[:code]

      requestToken = Typhoeus::Request.new("https://accounts.spotify.com/api/token", method: :post,
                                           body: {client_id: ENV["spotify_client_id"] ,
                                                  client_secret: ENV["spotify_client_secret"],
                                                  grant_type: "authorization_code",
                                                  code: @qParams['code'][0],
                                                  redirect_uri: session[:last_uri] } )
      requestToken.run

      responseToken = requestToken.response.body

      @tokenBody = JSON.parse(responseToken)

      session[:spotify_access_token] = @tokenBody['access_token']

      @session = session[:spotify_access_token]

      @user_signed_in = true

    else

      @user_signed_in = false

      session[:last_uri] = request.original_url

    end


  else
    @user_signed_in = false

  end

    if params[:search]

    search = params[:search]

    request = Typhoeus::Request.new("https://api.spotify.com/v1/search?q=#{URI.escape(search)}&type=track", method: :get )

      request.run

      response = request.response.body

      responseJson= JSON.parse(response)

      @rJson = responseJson['tracks']['items']

      #p params[:search]

    else

      @rJson = []
    end

  end


end
