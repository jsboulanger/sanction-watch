require File.join(File.dirname(__FILE__), '..', 'sanctionwatch.rb')

require 'rubygems'
require 'sinatra'
require 'lib/fetcher'
require 'rack/test'
require 'spec'
require 'spec/autorun'
require 'spec/interop/test'

# set test environment
set :environment, :test
set :run, false
set :raise_errors, true
set :logging, false



def search_mock
  m = mock(SearchEngine)
  m.stub!(:hits).and_return []
  m
end


class HaveTag
  def initialize(tag, count = 1)
    @tag, @count = tag, count
  end

  def matches?(target)
    @target = target
    REXML::Document.new(@target).elements.to_a(@tag).size == @count
  end

  def failure_message_for_should
    "expected #{@target.inspect} to have tag #{@tag} #{@count} times"
  end

  def failure_message_for_should_not
    "expected #{@target.inspect} not to have tag #{@tag} #{@count} times"
  end

end


def have_tag(tag, count = 1)
  HaveTag.new(tag, count)
end