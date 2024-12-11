class UserProvidersController < ApplicationController
  def index
    # display the users providers
    @user_providers = current_user.user_providers
  end

  def select
    @watch_providers = WatchProvider.all
  end

  def new
    # not required since
  end

  def create
    # fetch the user selection
    # save user selection into database as instances of user_providers table
    # send selected boxes through params
    @selected_provider_ids = params[:watch_provider_ids]
    yield
  end
end
