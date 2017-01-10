require_relative '../services/init_tournament'

class TournamentsController < ApplicationController
  include InitTournament
  
  def new
    @tournament = Tournament.new
  end
  
  def create
    @user = current_user
    @tournament = @user.tournaments.build(tournament_params)
    fill_serialized_team_data(@tournament)

    if @tournament.save
      InitTournament.create_teams(@tournament)
      InitTournament.create_matches_and_sub_brackets(@tournament)
      InitTournament.create_rounds(@tournament)
      InitTournament.assign_matches_to_rounds(@tournament)
      InitTournament.assign_required_seeds_to_matches(@tournament)
      InitTournament.assign_teams_to_first_round_matches(@tournament)
      flash[:notice] = "Tournament created successfully."
      render @tournament
    else
      flash[:alert] = "Invalid submission."
      redirect_to new_tournament_path
    end
  end
  
  def show
    @tournament = Tournament.find(params[:id])
    @sub_brackets = SubBracket.where(tournament_id: @tournament)
    @matches = Match.where(tournament_id: @tournament)
    @teams = Team.where(tournament_id: @tournament)
  end
  
  private
  
  def fill_serialized_team_data(record)
    params[:tournament][:team_names].each{ |name| record.team_names << name }
    params[:tournament][:team_seeds].each{ |seed| record.team_seeds << seed }
  end
  
  def tournament_params
    params.require(:tournament).permit(:name, :extra_game_option, :num_teams, :public)
  end
end
