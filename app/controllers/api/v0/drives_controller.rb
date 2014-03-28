module Api
  module V0
    class DrivesController < ApplicationController
      def create
        new_drive = true
        if params[:drive][:generic]
          @drive = Drive.create_generic(size: params[:drive][:size])
        else
          @drive = Drive.where(manufacturer: params[:drive][:manufacturer],
                               model: params[:drive][:model],
                               serial: params[:drive][:serial]).first
          new_drive = false unless @drive.nil?
          @drive ||= Drive.create(params[:drive])
        end

        if @drive.save
          render '_drive', {
            locals: {drive: @drive},
            format: :json,
            status: new_drive ? :created : :ok,
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
