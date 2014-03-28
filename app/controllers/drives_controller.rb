class DrivesController < ApplicationController
  layout 'with_sidebar'

  def index
    @drives = Drive.paginate(per_page: 25,
                              page: params[:page],
                              order: 'id ASC')
  end

  def show
    @drive = Drive.find(params[:id])
  end
end
