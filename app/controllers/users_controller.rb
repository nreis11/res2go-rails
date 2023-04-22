class UsersController < ApplicationController

  before_action :authenticate_user!

  def show
    @user = User.find(current_user.id)
    @stats = @user.stats.sort_by(&:id)
  end
end
