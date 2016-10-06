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
      /*
      * @desc event handler for changes made to the number of teams in a tournament
      * creates more team name input elements
      */
      document.getElementById('tournament_num_teams').onchange = function(e) {
        var num = e.srcElement.value, teamNameUl = document.getElementById('team-name-ul');
        teamNameUl.innerHTML = "";
        for( num ; num > 0; num -= 1) {
          teamNameUl.insertAdjacentHTML('beforeend', document.getElementById('team_name_template').innerHTML);
        }
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