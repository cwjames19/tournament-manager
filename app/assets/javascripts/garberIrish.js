var bracketCaptain = {
  common: {
    init: function() {
      console.log("application-wide code")
    }
  },
  sessions: {
    init: function() {
      console.log("Code for all actions in the sessions (users) controller");
    },
    show: function() {
      
    },
    new: function() {
      console.log("Code for sessions(user):new");
    }
  },
  tournaments: {
    init: function() {
      
    },
    new: function() {
      var loadTextFields = new Event('loadedTextFields');
      
      document.getElementById("tournament_num_teams").addEventListener('loadedTextFields', setSeedOptions);
      document.getElementById('tournament_num_teams').onchange = renderTeamNameFields;
      document.getElementById("tournament_seeded").onchange = disableSeedOptions;
      
      /*
      * @func renderTeamNameFields
      * @desc dynamically render the correct number of team name text fields
      */
      function renderTeamNameFields(e) {
        var num = e.srcElement.value, teamNameUl = document.getElementById('team-name-ul');
        
        teamNameUl.innerHTML = "";
        for ( num ; num > 0; num -= 1) {
          teamNameUl.insertAdjacentHTML('beforeend', document.getElementById('team_name_template').innerHTML);
        }
        e.srcElement.dispatchEvent(loadTextFields);
      }
      
      /*
      * @func setSeeds
      * @desc add the correct number of options to the seed select box with the correct values
      */
      function setSeedOptions(e) {
        var seed_elements = document.getElementsByClassName("tournament_team_seeds");
        var numTeams = e.srcElement.value;

        for ( var el = 0 ; el <= numTeams ; el += 1 ) {
          seed_elements[el].innerHTML = "";
          seed_elements[el].insertAdjacentHTML('beforeend', "<option value=''></option>" );
          for( var count = 1 ; count <= numTeams ; count += 1 ) {
            seed_elements[el].insertAdjacentHTML('beforeend', "<option value='" + count + "'>" + count + "</option>" );
          }
        }
      }
      
      function disableSeedOptions(e) {
        var seedSelectBoxes = $('.tournament_team_seeds, .tournament_team_seeds_label');
        e.srcElement.checked == false ? seedSelectBoxes.css("display", "none") : seedSelectBoxes.css("display", "initial");
      }
    },
    show: function() {
      
    },
    update: function() {
      
    },
  }
};

var util = {
  exec: function( controller, action ) {
    var bc = bracketCaptain, action = ( action === undefined ) ? "init" : action;
    if ( controller !== "" && bc[controller] && typeof bc[controller][action] == "function" ) {
      bc[controller][action]();
    }
  },
  init: function() {
    var body = document.body, controller = body.getAttribute( "data-controller" ), action = body.getAttribute( "data-action" );
    util.exec( "common" );
    util.exec( controller );
    util.exec( controller, action );
  }
};

$( document ).ready( util.init );
$( document ).on('page:load', util.init );