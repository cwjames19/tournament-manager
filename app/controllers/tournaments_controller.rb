class TournamentsController < ApplicationController
  # require 'app/services/tournaments/new.rb'
  
  def new
    @tournament = Tournament.new
  end
  
  def create
    @user = current_user
    @tournament = @user.tournaments.build(tournament_params)
    
    begin
      
      
      if @tournament.validate!
        @tournament.save!
      else
        flash[:alert] = "Didn't pass validation.\n Please try again."
        render new_tournament_path and return
      end
    rescue
      flash[:alert] = "Unknown error raised. Please try again."
      render new_tournament_path and return
    end
    
    flash[:notice] = "Tournament created."
    redirect_to @tournament
  end
  
  def show
    @tournament = Tournament.find(params[:id])
  end
  
  private
  
  def tournament_params
    params.require(:tournament).permit(:name, :tournament_type, :extra_game_option, :num_teams, :public, :teams_raw, :normal_scoring)
  end
end
