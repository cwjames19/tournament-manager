class TournamentsController < ApplicationController
  
  def new
    @tournament = Tournament.new
    @foo = "bar"
  end
  
  def create
    @user = current_user
    @tournament = @user.tournaments.build(tournament_params)

    if @tournament.save!
        build_teams
        flash[:alert] = "Tournament created successfully."
        redirect_to @tournament
      else
        flash[:alert] = "Didn't pass validation.\n Please try again."
        render new_tournament_path #and return
    end
  end
  
  def show
    @tournament = Tournament.find(params[:id])
  end
  
  private
  
  def build_teams
    BuildTeams.new({
      tournament: current_user.tournaments.last,
      names: params[:tournament][:team_names],
      seeds: params[:tournament][:team_seeds]
    }).create_teams
  end
  
  def tournament_params
    params.require(:tournament).permit(:name, :extra_game_option, :num_teams, :public)
  end
end
