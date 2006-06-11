class ClassTreesController < ApplicationController
  def index
    list
    render :action => 'list'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  def list
    @class_tree_pages, @class_trees = paginate :class_trees, :per_page => 10
  end

  def show
    @class_tree = ClassTree.find(params[:id])
  end

  def new
    @class_tree = ClassTree.new
  end

  def create
    @class_tree = ClassTree.new(params[:class_tree])
    if @class_tree.save
      flash[:notice] = 'ClassTree was successfully created.'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end

  def edit
    @class_tree = ClassTree.find(params[:id])
  end

  def update
    @class_tree = ClassTree.find(params[:id])
    if @class_tree.update_attributes(params[:class_tree])
      flash[:notice] = 'ClassTree was successfully updated.'
      redirect_to :action => 'show', :id => @class_tree
    else
      render :action => 'edit'
    end
  end

  def destroy
    ClassTree.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
end
