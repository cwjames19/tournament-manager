class TournamentsController < ApplicationController
  def new
    @tournament = Tournament.new
  end
  
  def create
    @tournament = @user.tournaments.build(tournament_params)
    
    if @tournament.save!
      flash[:notice] = "Tournament created."
      redirect_to @tournament
    else
      flash[:warning] = "An error occurred. Please try again."
      render new_tournament_path
    end
  end
  
  def show
    @tournament = Tournament.find(params[:id])
  end
  
  private
  
  def tournament_params
    params.require(:tournament).permit(:name, :tournament_type, :play_out_all_games, :bronze_medal_game, :image, :public, :teams, :normal_scoring)
  end
end
