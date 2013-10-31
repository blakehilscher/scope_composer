$:.unshift File.join(File.dirname(__FILE__), *%w[.. lib])

require 'pry'
require "rspec"
require "scope_composer"