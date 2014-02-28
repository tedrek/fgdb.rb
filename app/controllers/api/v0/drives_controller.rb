module Api
  module V0
    class DrivesController < ApplicationController
      def create
        @drive = Drive.create(params[:drive])
        if @drive.save
          render '_drive', {
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
        @drive = Drive.find(params[:id])
        render '_drive', format: :json
      end

      def update
        @drive = Drive.find(params[:id])
        @drive.update_attributes!(params[:drive])
        render '_drive', format: :json
      end
    end
  end
end
