// It's only ES3 compatible
// You don't have a console.log, you need send a "debug"

function play(params) {
  var return_obj = {
    'debug': 'true',
    'action': 'shoot',
    'params': params
  };
  return_obj['params']['my_own'] = 'custom param to debug';
  return return_obj;
}
