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
  //                3 - the hp of enemy
  // * direction - if -1 so you seeing to the left, otherwise, you seeing to the right
  // * pos_x     - your position in the x axis
  // * pos_y     - your position in the y axis
  // * last_shoot_x - the x axis of last missile hit
  // * last_shoot_y - the y axis of last missile hit
  // * moves     - remaining moves in the turn

  // The actions available:
  // * shoot_15   - shoot with 15 of force and go to next enemy, you can change the 15 to 2-30
  // * aim_up_2   - move the aim to up 2 angle, you can change the 2 to 2-170
  // * aim_down_2 - move the aim to down 2 angle, you can change the 2 to 2-170
  // * walk_left_2  - move to the left 2 points in the x axis, you can change the 2 to 2-170
  // * walk_right_2 - move to the right 2 points in the x axis, you can change the 2 to 2-170
  // * jump_left  - jump to the left
  // * jump_right - jump to the right
  // * jump       - just jump
  // * none       - don't anything
  var action = 'shoot_10';

  var return_obj = {
    'debug': 'true',
    'action': action,
    'params': params
  };
  return_obj['params']['custom_params'] = {
    'last_x': params['pos_x'],
    'last_action': action
  };
  return return_obj;
}
