class TournamentsController < ApplicationController
  
  def new
    @tournament = Tournament.new
  end
  
  def create
    @user = current_user
    @tournament = @user.tournaments.build(tournament_params)
    fill_serialized_team_data(@tournament)
    # binding.pry

    if @tournament.save
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
        flash[:alert] = "Invalid submission."
        render new_tournament_path
    end
  end
  
  def show
    @tournament = Tournament.find(params[:id])
  end
  
  private
  
  def create_matches
    cm_instance = CreateMatches.new(current_user.tournaments.last)
    cm_instance.create_matches
    cm_instance.assign_all_win_loss_records_to_matches()
  end
  
  def create_teams
    CreateTeams.new({ tournament: current_user.tournaments.last }).create_teams
  end
  
  def fill_serialized_team_data(record)
    params[:tournament][:team_names].each{ |name| record.team_names << name }
    params[:tournament][:team_seeds].each{ |seed| record.team_seeds << seed }
  end
  
  def tournament_params
    params.require(:tournament).permit(:name, :extra_game_option, :num_teams, :public)
  end
end
