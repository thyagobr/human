#!/usr/bin/env ruby
#
HUMAN_ROOT = File.expand_path('../../', __FILE__)
$:.unshift("#{HUMAN_ROOT}/src")

require 'gosu'
require 'game'

game = Game.new.show
