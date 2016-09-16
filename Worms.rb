# Encoding: UTF-8

ROOT_DIR = File.dirname(__FILE__)
GAME_TIME = 2 # In minutes

require_relative 'lib/worms'

# So far we have only defined how everything *should* work - now set it up and run it!
Worms::Worms.new.show if __FILE__ == $0
