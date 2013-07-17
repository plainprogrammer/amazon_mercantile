require 'rubygems'
require 'bundler'
Bundler.require(:default, :development, :test)

require 'minitest/autorun'
require 'minitest/spec'

require 'simplecov'
SimpleCov.start

$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'amazon_mercantile'
