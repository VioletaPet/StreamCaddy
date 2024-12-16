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
    @media = Media.find(params[:media_id])

    @watchlist_media = current_user.watchlist_media.new(media: @media)
    if @watchlist_media.save
      redirect_to watchlist_media_path(@watchlist_media), notice: "Item has been added to your watchlist"
    else
      redirect_to media_path, alert: 'Failed to add item to your Watchlist'
    end
  end

  def schedule
    platform_count = params[:platform_count].to_i
    if platform_count > 0
      user_providers = current_user.watch_providers.pluck(:id)
      @schedule = current_user.suggest_content_schedule(platform_count, user_providers)
    else
      @schedule = []
      flash[:alert] = "Please select a valid number of platforms."
    end
    render :schedule
  end




  def destroy
    @watchlist_media = current_user.watchlist_media.find(params[:id])
    @watchlist_media.destroy
    redirect_to watchlist_media_path, status: :see_other
  end
end
