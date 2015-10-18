#!/usr/bin/env ruby
#
HUMAN_ROOT = File.expand_path('../../', __FILE__)
$:.unshift("#{HUMAN_ROOT}/lib")
$:.unshift("#{HUMAN_ROOT}/lib/human")

require 'gosu'
require 'human'

game = Main.new.show
