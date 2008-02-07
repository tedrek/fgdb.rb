#!/usr/bin/env ruby
ENV["RAILS_ENV"] = "test"
#require File.dirname(__FILE__) + "/../../../../config/environment"
#require 'test_help'
#require 'action_view'
#include ActionView::Helpers::FormTagHelper
require 'test/unit'
require 'yaml'
require File.dirname(__FILE__) + "/../lib/datalist"

def text_field_tag(*args)
  args.join( ", " )
end
alias :text_area_tag :text_field_tag
alias :link_to_remote :text_field_tag
alias :check_box_tag :text_field_tag

class DatalistTest < Test::Unit::TestCase

  class TestCol
    def initialize(name)
      @human_name = name
    end
    attr_accessor :human_name
    alias :name :human_name
    def type
      [:boolean, :text, nil][rand(3)]
    end
  end
  class TestItem
    attr_accessor :test0, :test1, :test2, :no_test
    def self.content_columns
      %w[ test0 test1 test2 no_test ].map {|name| TestCol.new(name)}
    end
    def attributes=(dict)
      dict.each {|k,v|
        send(k.to_s+"=", v)
      }
    end
  end

  def test_000_should_init
    assert  Datalist
    assert_kind_of Class, Datalist
    retval = nil
    assert_nothing_raised   {retval = Datalist.new('meow', TestItem)}
    assert_kind_of Datalist, retval
    retval = nil
    assert_nothing_raised   {retval = Datalist.new('meow', TestItem, :datalist_aware_form => false)}
    assert_kind_of Datalist, retval
    retval = nil
    assert_raises( ArgumentError )  {retval = Datalist.new('meow')}
  end

  def test_010_should_render
    retval = nil
    list = retval1 = Datalist.new('meow', TestItem, :exclude => [:no_test])
    assert_nothing_raised   {retval = list.render}
    assert_kind_of String, retval
    assert_match /test0/, retval
    assert_match /test1/, retval
    assert_match /test2/, retval
    assert_no_match /no_test/, retval
    assert_match /table/, retval
    assert_match /\/table/, retval
  end

  def test_040_should_load
    retval = nil
    params = {'meow' => {
        :model => "DatalistTest::TestItem",
        :created => [{:test0 => 1, :test1 => "foo"}, {:test1 => 2}],
        :updated => []
      }}
    assert_nothing_raised   { retval = Datalist.load('meow', params) }
    assert_kind_of Datalist, retval
    assert ! retval.objects.empty?
    assert_kind_of TestItem, retval.objects[0]
  end

end # class DatalistTest
