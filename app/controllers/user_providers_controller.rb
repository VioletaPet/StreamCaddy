class UserProvidersController < ApplicationController
  def index
    @user_providers = current_user.watch_providers
  end

  def edit
    @watch_providers = WatchProvider.all
    @user_providers = current_user.watch_providers.pluck(:id)
  end

  def update
    if params[:user_provider_selection] && params[:user_provider_selection][:watch_provider_ids]
      current_user.watch_provider_ids = params[:user_provider_selection][:watch_provider_ids].map(&:to_i)
    else
      current_user.watch_provider_ids = []
    end
    if current_user.save
      redirect_to user_providers_path, notice: "Selections updated successfully!"
    else
      flash[:alert] = "Unable to update selections. Please try again."
      render :edit
    end
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
    @provider.destroy
    redirect_to user_providers_path
  end


end
