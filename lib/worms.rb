require 'rubygems'
require 'gosu'
require 'rmagick'

WIDTH, HEIGHT = 600, 600

NULL_PIXEL = Magick::Pixel.from_color('none')

require_relative 'worms/version'
require_relative 'worms/map'
require_relative 'worms/player'
require_relative 'worms/missile'
require_relative 'worms/particle'
require_relative 'worms/worms'
