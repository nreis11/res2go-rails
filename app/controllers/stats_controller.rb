class StatsController < ApplicationController

  def new
    @user = current_user
    @stat = Stat.new
    @reservoirs = Reservoir.all
  end

  def create
    @reservoir = Reservoir.find_by(name: params["reservoir_name"])
    @stat = Stat.new(user_id: current_user.id,
                     reservoir_id: @reservoir.id,
                     min: params["min"],
                     max: params["max"])

    respond_to do |format|
      if @stat.save
        format.html { redirect_to user_path(current_user) }
      else
        @user = current_user
        @reservoirs = Reservoir.all
        format.html { render :new }
      end
    end
  end

  def edit
    @stat = Stat.find(params[:id])
  end

  def update
    @stat = Stat.find(params[:id])
    if @stat.update(min: params["stat"][:min], max: params["stat"][:max])
      redirect_to user_path
    else
      render :edit
    end
  end

  def destroy
    @stat = Stat.find(params[:id])
    @stat.destroy
    redirect_to user_path, :notice => "Reservoir has been successfully deleted."
  end
  
end
