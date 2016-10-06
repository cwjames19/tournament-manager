// # Place all the behaviors and hooks related to the matching controller here.
// # All this logic will automatically be available in application.js.
// # You can use CoffeeScript in this file: http://coffeescript.org/

window.onload = function() {
  var elNumTeams = document.getElementById('tournament_num_teams');
  var teamNameUl = document.getElementById('team-name-ul');

  /*
   * @desc event handler for changes made to the number of teams in a tournament
   * creates more team name input elements
  */
  elNumTeams.onchange = function() {
    var num = elNumTeams.value;
    teamNameUl.innerHTML = "";
    
    for(num; num > 0; num -= 1) {
      teamNameUl.insertAdjacentHTML('beforeend', document.getElementById('team_name_form').innerHTML);
    }
  };
};