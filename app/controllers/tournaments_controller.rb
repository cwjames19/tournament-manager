class TournamentsController < ApplicationController
  
  def new
    @tournament = Tournament.new
  end
  
  def create
    @user = current_user
    @tournament = @user.tournaments.build(tournament_params)
    fill_serialized_team_data(@tournament)

    if @tournament.save
      create_teams
      create_matches_and_sub_brackets
      assign_first_matches
      flash[:notice] = "Tournament created successfully."
      redirect_to @tournament
    else
      flash[:alert] = "Invalid submission."
      render new_tournament_path
    end
  end
  
  def show
    @tournament = Tournament.find(params[:id])
  end
  
  private
  
  def assign_first_matches
    AssignFirstMatches.new(@tournament).assign_first_round
  end
  
  def create_matches_and_sub_brackets
    inst = CreateMatchesAndSubBrackets.new(@tournament)
    inst.create_matches
    inst.assign_win_loss_records_and_consolation_sub_brackets
  end
  
  def create_teams
    CreateTeams.new(@tournament).create_teams
  end
  
  def fill_serialized_team_data(record)
    params[:tournament][:team_names].each{ |name| record.team_names << name }
    params[:tournament][:team_seeds].each{ |seed| record.team_seeds << seed }
  end
  
  def tournament_params
    params.require(:tournament).permit(:name, :extra_game_option, :num_teams, :public)
  end
end
