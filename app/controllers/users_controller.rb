class UsersController < ApplicationController
  before_action :authenticate_user!

  def show
    @user = current_user
  end

  def genre_calcs
    user_genres = current_user.genres
    calculate_genre_percentages(user_genres)
  end
end
