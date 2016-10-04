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
      console.log("code for the tournaments:new action");
      /*
      * @desc event handler for changes made to the number of teams in a tournament
      * creates more team name input elements
      */
      document.getElementById('tournament_num_teams').onchange = function(e) {
        console.log("inside the first onchange callback");
        var num = e.srcElement.value, teamNameUl = document.getElementById('team-name-ul');
        teamNameUl.innerHTML = "";
        
        for ( num ; num > 0; num -= 1) {
          teamNameUl.insertAdjacentHTML('beforeend', document.getElementById('team_name_template').innerHTML);
        }
      };
      
      document.getElementById('tournament_num_teams').onchange = function(e) {
        var setSeeds = function() {
          console.log("in the second onChange callback")
          var num = e.srcElement.value
          var seed_elements = document.getElementsByClassName("tournament_team_seeds")
          
          for ( var el = 0 ; el <= seed_elements.length ; el += 1 ) {
            seed_elements[el].innerHTML = "";
            seed_elements[el].insertAdjacentHTML('beforeend', "<option value=''></option>" )
            for( var count = 1 ; count <= num ; count += 1 ) {
              seed_elements[el].insertAdjacentHTML('beforeend', "<option value='" + count + "'>" + count + "</option>" )
            }
          }
        };
        
        setTimeout(setSeeds, 300);
      };
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