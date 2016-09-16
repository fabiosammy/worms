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
  // * aim_up_2   - move the aim to up 0 angle, you can change the 2 to 2-170
  // * aim_down_2 - move the aim to down 0 angle, you can change the 2 to 2-170
  // * walk_left  - move to the left
  // * walk_right - move to the right
  // * jump_left  - jump to the left
  // * jump_right - jump to the right
  // * jump       - just jump
  var action = 'shoot';

  var return_obj = {
    'debug': 'true',
    'action': action,
    'params': params
  };
  return_obj['params']['custom_params'] = 'custom param to next access';
  return return_obj;
}
