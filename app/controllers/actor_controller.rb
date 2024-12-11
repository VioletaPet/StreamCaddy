class ActorController < ApplicationController
  def show
    @actor = Actor.find_by(id: params[:format])
  end
end
