require 'forwardable'
require 'optparse'
require 'yaml'
require 'rubygems'
require 'net/toc'
require 'treetop'
require 'twitter'

module Roflbot
end

require File.dirname(__FILE__) + "/roflbot/base"
require File.dirname(__FILE__) + "/roflbot/sentence_bot"
require File.dirname(__FILE__) + "/roflbot/runner"
