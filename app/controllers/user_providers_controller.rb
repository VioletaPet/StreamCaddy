class UserProvidersController < ApplicationController
  def index
    @user_providers = current_user.watch_providers
  end

  def select
    @available_providers = WatchProvider.where.not(id: current_user.user_providers.select(:watch_provider_id))
  end

  def create
    @selected_provider_ids = params[:user_provider_selection][:watch_provider_ids]
    @selected_provider_ids.shift

    if @selected_provider_ids.present?
      @selected_provider_ids.each do |provider_id|
        unless current_user.user_providers.exists?(watch_provider_id: provider_id)
        current_user.user_providers.create!(watch_provider_id: provider_id)
        end
      end
      redirect_to user_providers_path, notice: "Streaming platforms added successfully!"
    else
      redirect_to user_providers_select_path, alert: "Please select at least one streaming platform."
    end
  end

  def destroy
    @provider = current_user.user_providers.find(params[:id])
    yield
    @provider.destroy
  end
end
