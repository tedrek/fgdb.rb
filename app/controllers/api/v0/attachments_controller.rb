module Api
  module V0
    class AttachmentsController < ApplicationController
      layout nil

      def create
        @attachment = Attachment.new(file: params[:file],
                                     attachable_type: params[:attachable_type],
                                     attachable_id: params[:attachable_id])
        if @attachment.save
          render 'success', format: :json
        else
          render 'errors', format: :json, status: :bad_request
        end
      end

      def show
        @attachment = Attachment.find(params[:id])
      end

      def data
        @attachment = Attachment.find(params[:id])
        send_file @attachment.filename,
          filename: @attachment.name,
          type: @attachment.content_type
      end
    end
  end
end
