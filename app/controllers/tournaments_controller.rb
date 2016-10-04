class TournamentsController < ApplicationController
  
  def new
    @tournament = Tournament.new
    @foo = "bar"
  end
  
  def create
    # begin
      @user = current_user
      binding.pry
      @tournament = @user.tournaments.build(tournament_params)

      if @tournament.save!
          flash[:alert] = "Passed validation and saved."
          redirect_to @tournament
        else
          flash[:alert] = "Didn't pass validation.\n Please try again."
          render new_tournament_path #and return
      end
    # rescue
    #   puts "create action failed and rescued"
    #   render new_tournament_path
    # end

  end
  
  def show
    @tournament = Tournament.find(params[:id])
  end
  
  private
  
  def tournament_params
    params.require(:tournament).permit(:name, :tournament_type, :extra_game_option, :num_teams, :public, :teams_raw, :normal_scoring)
  end
end
