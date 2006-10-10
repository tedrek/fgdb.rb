require File.dirname(__FILE__) + '/../../../../test/test_helper'

class SearchableItem < ActiveRecord::Base
  include MojoDNA::Searchable
  
  attr_accessor :name, :description, :summary, :subitem
  index_path "/tmp/searchable"
  
  index_attr :name
  index_attr :summary, :indexed_name => "shortdesc", :aliases => ["summary", "abstract"], :boost => 2, :indexed => false, :stored => true, :tokenized => false, :sortable => true
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

# class A < ActiveRecord::Base; end
# 
# class AnotherSearchableItem < A
#   include MojoDNA::Searchable
#   
#   index_path "/tmp/another_index"
# end

class CustomSearchableItem < ActiveRecord::Base
  include MojoDNA::Searchable
  
  def to_doc
    doc = Document.new
    doc << MojoDNA::Searchable::Indexer::create_field("name", "CustomSearchableItem")
    doc
  end
end

class SearchableTest < Test::Unit::TestCase
  include MojoDNA::Searchable
  
  def initialize(*args)
    super
  end
  
  def setup
    ActiveRecord::Base.connection.drop_table :custom_searchable_items rescue nil
    ActiveRecord::Base.connection.drop_table :searchable_items rescue nil

    ActiveRecord::Base.connection.create_table :custom_searchable_items do |t|
      t.column :name, :string
      t.column :description, :text
    end

    ActiveRecord::Base.connection.create_table :searchable_items do |t|
      t.column :name, :string
      t.column :description, :text
      t.column :summary, :text
    end
    
    FileUtils.rm_f("/tmp/searchable")
  end
  
  def test_class_methods
    assert( SearchableItem.respond_to?(:index_path) )
    assert( SearchableItem.respond_to?(:searchable_fields) )
    assert( SearchableItem.respond_to?(:search) )
  end
  
  def test_instance_methods
    item = SearchableItem.new
    assert( item.respond_to?(:add_to_index) )
  end

  def test_dsl
    assert_equal("/tmp/searchable", SearchableItem.index_path)
    fields = SearchableItem.searchable_fields
    assert_equal( 4, fields.length )
    
    name_field = fields[:name]
    assert( name_field.is_a?(SearchableField) )
    assert_equal( :name, name_field.attr_name )
    assert_equal( :name, name_field.indexed_name )
    assert_equal( [], name_field.aliases )
    assert_equal( 1.0, name_field.boost )
    assert( name_field.indexed? )
    assert( !name_field.stored? )
    assert( name_field.tokenized? )
    assert( !name_field.sortable? )
    
    desc_field = fields[:description]
    assert_equal( :description, desc_field.attr_name )
    assert_equal( :text, desc_field.indexed_name )
    assert_equal( ["body", "desc", "description"].sort, desc_field.aliases.sort )
    assert_equal( 2.0, desc_field.boost )
    assert( !desc_field.indexed? )
    assert( desc_field.stored? )
    assert( !desc_field.tokenized? )
    assert( desc_field.sortable? )
    
    sub_field = fields[:subitem]
    assert_equal( :subitem, sub_field.attr_name )
    sub_name = sub_field.include[:name]
    assert_equal( :name, sub_name.attr_name )
    assert_equal( :sub_name, sub_name.indexed_name )
  end
  
  def test_named_args
    fields = SearchableItem.searchable_fields
    assert_equal( 4, fields.length )
    
    summary_field = fields[:summary]
    assert_equal( :summary, summary_field.attr_name )
    assert_equal( :shortdesc, summary_field.indexed_name )
    assert_equal( ["summary", "abstract"].sort, summary_field.aliases.sort )
    assert_equal( 2.0, summary_field.boost )
    assert( !summary_field.indexed? )
    assert( summary_field.stored? )
    assert( !summary_field.tokenized? )
    assert( summary_field.sortable? )
  end
  
  def test_add_to_index
    item = SearchableItem.new
    item.name = "An item"
    item.description = "The item's description."
    item.add_to_index
    
    results = SearchableItem.search("name:item", :load => false)
    assert( results.length == 1 )
    assert_equal( 0, results.first.id )
  end
  
  def test_search
    item = SearchableItem.new
    item.name = "An item"
    item.description = "The item's description."
    item.save

    results = SearchableItem.search("name:item")
    assert( results.length == 1 )
    item = results.first
    assert( item.is_a?(SearchableItem) )
  end
  
  def test_to_doc
    item = CustomSearchableItem.new
    item.save
    
    results = CustomSearchableItem.search("name:CustomSearchableItem")
    assert( results.length == 1 )
    item = results.first
    assert( item.is_a?(CustomSearchableItem) )
  end
  
#  def test_inheritance
#    item = AnotherSearchableItem.new
#  end
end