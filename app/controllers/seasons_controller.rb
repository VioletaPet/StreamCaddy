class SeasonsController < ApplicationController
  def show
    @season = Season.find(params[:id])
    @media = @season.media
  end
end
