class ActorController < ApplicationController
  def show
    @actor = Actor.find_by(id: params[:format])
    @media = @actor.medias.first
  end
end
