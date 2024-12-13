class UsersController < ApplicationController
  before_action :authenticate_user!

  def show
    @user = current_user
    @genre_percentages = calculate_genre_percentages(@user.genres)
    @creator_percentages = calculate_user_creators(@user)
  end

  def calculate_genre_percentages(user_genres)
    genre_count = user_genres.each_with_object(Hash.new(0)) do |genre, counts|
      counts[genre.name] += 1
    end

    total_count = genre_count.values.sum

    genre_percentages = genre_count.transform_values do |count|
      ((count.to_f / total_count) * 100).round(2)
    end

    genre_percentages
  end

  def calculate_user_creators(user)
    creators = user.watchlist_media.map do |m|
      creator = m.media.creator
    end

    creator_count = creators.tally

    total_count = creator_count.values.sum

    creator_percentages = creator_count.transform_values do |count|
      ((count.to_f / total_count) * 100).round(2)
    end

    creator_percentages
  end



end
