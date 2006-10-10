require File.dirname(__FILE__) + '/../../../../test/test_helper'

class SearchableItem < ActiveRecord::Base
  include MojoDNA::Searchable
  
  attr_accessor :name, :description #, :subitem
  index_path "/tmp/searchable"
  
  index_attr :name
  index_attr :description do |attr|
    attr.indexed_name "text"
    attr.aliases ["body", "desc", "description"]
    attr.boost 2.0
    attr.indexed false
    attr.stored true
    attr.tokenized false
    attr.sortable true
  end
  index_attr :subitem do |attr|
    attr.include :name do |s|
      s.indexed_name :sub_name
    end
  end
end

class IndexerTest < Test::Unit::TestCase
  include MojoDNA::Searchable
  
  def initialize(*args)
    super
  end
  
  def setup
  end
  
  def test_class_methods
    assert( Indexer.respond_to?(:get_index) )
    assert( Indexer.respond_to?(:delete_from_index) )
    assert( Indexer.respond_to?(:index) )
    assert( Indexer.respond_to?(:create_field) )
    assert( Indexer.respond_to?(:create_doc) )
  end
  
  def test_create_field
    field = Indexer.create_field("name", "An item")
    assert( field.is_a?(Ferret::Document::Field) )
    assert_equal( "name", field.name )
  end
  
  def test_create_doc
    item = SearchableItem.new
    item.name = "An item"
    item.description = "The item's description."
    
    name_field = SearchableField.new
    name_field.attr_name = :name
    doc = Indexer.create_doc( item, [name_field] )
    assert( doc.is_a?(Ferret::Document) )
    assert_equal( 1, doc.field_count )
  end
  
  def test_index
    item = SearchableItem.new
    item.name = "An item"
    item.description = "The item's description."
    
    Indexer.delete_from_index( item )
    Indexer.index( item )
  end
end