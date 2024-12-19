class WatchlistMediaController < ApplicationController
  def index

    @watchlist = current_user.watchlist_media.includes(media: :watch_providers)
    user_providers = current_user.user_providers.pluck(:watch_provider_id)


    @provider_content = Hash.new { |hash, key| hash[key] = { free: [], paid: [] } }
    @unreleased_content = []

    @watchlist.each do |item|
      media_item = item.media
      next unless media_item


      if media_item.watch_providers.empty?
      score = current_user.score_media_item(media_item, 'unreleased')
      @unreleased_content << { media: media_item, score: score }
      next
      end

      media_item.watch_providers.each do |provider|
        next unless user_providers.include?(provider.id)

        media_watch_provider = media_item.media_watch_providers.find_by(watch_provider: provider)
        provider_type = if media_watch_provider&.flatrate
                          'free'
                        elsif media_watch_provider&.rent
                          'rent'
                        else
                          'paid'
                        end


        score = current_user.score_media_item(media_item, provider_type)


        if provider_type == 'free'
          @provider_content[provider][:free] << { media: media_item, score: score }
        else
          @provider_content[provider][:paid] << { media: media_item, score: score }
        end
      end
    end

    @provider_content.each do |provider, content|
      content[:free] = content[:free].sort_by { |item| -item[:score] }
      content[:paid] = content[:paid].sort_by { |item| -item[:score] }

    end
    @unreleased_content = @unreleased_content.sort_by { |item| -item[:score] }

  end

  def show
    @watchlist_media = current_user.watchlist_media.find(params[:id])
  end

  def create
    @media = Media.find_by(id: params[:media_id]) || Media.find_by(api_id: params[:media_id])
    if params[:title].present?
      media_params = { title: params[:title], id: params[:media_id] }
    else
      media_params = { name: params[:name], id: params[:media_id] }
    end

    if @media
      @watchlist_media = current_user.watchlist_media.new(media: @media)
      @watchlist_media.save!
    else
      LikeMediaJob.perform_later(current_user.id, media_params)
    end
  end

  def schedule
    @platform_count = params[:platform_count].to_i
    user_providers = current_user.watch_providers.pluck(:name) # Assuming this fetches provider names

    if @platform_count > 0
      media_scores = current_user.calculate_media_scores
      provider_groups = current_user.group_by_provider(media_scores)
      @schedule = current_user.generate_watchlist(provider_groups, max_providers_per_month: @platform_count)

      @user_selected_providers = user_providers
    else
      @schedule = []
      flash[:alert] = "Please select a valid number of platforms."
    end
  end

  def schedule_month
    @selected_month = params[:month].to_i
    @platform_count = params[:platform_count].to_i
    media_scores = current_user.calculate_media_scores
    provider_groups = current_user.group_by_provider(media_scores)
    @schedule = current_user.generate_watchlist(provider_groups, max_providers_per_month: @platform_count)
    # raise

    month_data = @schedule&.find { |month| month[:month] == @selected_month }

    if month_data
      @month_providers = month_data[:providers]
      @displayed_month = Date.today.next_month(@selected_month - 1).strftime("%B")
    else
      redirect_to schedule_watchlist_media_path, alert: "Month not found"
    end
  end


  def destroy
    @watchlist_media = current_user.watchlist_media.find(params[:id])
    @watchlist_media.delete
    redirect_to watchlist_media_path, status: :see_other
  end
end
