class TournamentsController < ApplicationController
  
  def new
    @tournament = Tournament.new
    @foo = "bar"
  end
  
  def create
    @user = current_user
    @tournament = @user.tournaments.build(tournament_params)
    # @tournament.write_attribute(:extra_game_option, params[:tournament][:extra_game_option])
    binding.pry
    
    if @tournament.save!
        # begin
          create_teams
          create_matches
          flash[:notice] = "Tournament created successfully."
          redirect_to @tournament
        # rescue
        #   # Destroy tournament and its entities.
        #   flash[:error] = "There was a problem while creating your tournament."
        #   render new_tournament_path
        # end
      else
        flash[:alert] = "Didn't pass validation.\n Please try again."
        render new_tournament_path #and return
    end
  end
  
  def show
    @tournament = Tournament.find(params[:id])
  end
  
  private
  
  def create_matches
    cm_instance = CreateMatches.new({tournament: current_user.tournaments.last, extra_game_option: params[:tournament][:extra_game_option].to_i})
    cm_instance.create_matches
    # cm_instance.assign_matches
  end
  
  def create_teams
    CreateTeams.new({
      tournament: current_user.tournaments.last,
      names: params[:tournament][:team_names],
      seeds: params[:tournament][:team_seeds]
    }).create_teams
  end
  
  def tournament_params
    params.require(:tournament).permit(:name, :extra_game_option, :num_teams, :public)
  end
end
