module Api
  module V0
    class DrivesController < ApplicationController
      def create
        @drive = Drive.create(params[:drive])
        if @drive.save
          render '_drive', {
            locals: {drive: @drive},
            format: :json,
            status: :created,
            location: "/api/v0/drives/#{@drive.id}",
          }
        end
      end

      def destroy
        Drive.destroy(params[:id])
        render '_blank', format: :json
      end

      def index
        @drives = Drive.find(:all)
      end

      def show
        begin
          @drive = Drive.find(params[:id])
        rescue ActiveRecord::RecordNotFound
          render '_error', format: :json, locals: {errors: ['Record not found']}
          return
        end
        render '_drive', format: :json, locals: {drive: @drive}
      end

      def update
        @drive = Drive.find(params[:id])
        @drive.update_attributes!(params[:drive])
        render '_drive', format: :json, locals: {drive: @drive}
      end
    end
  end
end
