#!/usr/bin/env ruby
#$LOAD_PATH << File.dirname(__FILE__)

require 'chingu'
require 'pry'
require_all "#{ROOT}/app"

LD20::MainWindow.new.show