$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'Lmfs'
require 'minitest/autorun'

require 'pp'
require 'minitest/reporters'
Minitest::Reporters.use! [Minitest::Reporters::SpecReporter.new, Minitest::Reporters::HtmlReporter.new]
