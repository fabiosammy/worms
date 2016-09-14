# Encoding: UTF-8

require_relative 'lib/worms'

# So far we have only defined how everything *should* work - now set it up and run it!
Worms::Worms.new.show if __FILE__ == $0
