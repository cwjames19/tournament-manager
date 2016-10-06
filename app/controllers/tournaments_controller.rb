class TournamentsController < ApplicationController
  def new
    @tournament = Tournament.new
  end
  
  def create
    @user = current_user
    @tournament = @user.tournaments.build(tournament_params)
    
    begin
      new_tournament = InitTournament.new(tournament_params)
      
      if @tournament.validate! && new_tournament.validate_teams.success?
        @tournament.save!
      else
        flash[:alert] = "Didn't pass validation. #{new_tournament.validate_teams.data}.\n Please try again."
        render new_tournament_path and return
      end
      
      new_tournament.fill_in_tournament(Tournament.last)
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
