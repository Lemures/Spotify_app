class TracksController < ApplicationController

  def index
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

  def new

  end

  def create

  end

end
