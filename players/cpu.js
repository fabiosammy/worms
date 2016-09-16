// It's only ES3 compatible
// This script will be compile by "execjs"
// You don't have a console.log, you need send a "debug"
// You have 5 seconds to do 3 moves and shoot in each turn.

function play(params) {
  // The params object has:
  // * name      - the name of player
  // * enemies   - a array with arrays of enemies, with the indexes:
  //                0 - the enemy name
  //                1 - the distance of enemy alive.
  //                    If the value is < 0, than the enemy is to the left
  //                    If the value is >= 0, than the enemy is to the right
  //                2 - the y axis of enemy
  // * direction - if -1 than you see to the left, otherwise, you see to the right
  // * pos_x     - your position in the x axis
  // * pos_y     - your position in the y axis

  // The actions disponible:
  // * shoot      - shoot and go to next enemie
  // * aim_up     - move the aim to up angle
  // * aim_down   - move the aim to down angle
  // * walk_left  - move to the left
  // * walk_right - move to the right
  var action = 'shoot';

  var return_obj = {
    'debug': 'true',
    'action': action,
    'params': params
  };
  return_obj['params']['my_own'] = 'custom param to debug';
  return return_obj;
}
