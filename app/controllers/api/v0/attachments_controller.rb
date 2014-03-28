module Api
  module V0
    class AttachmentsController < ApplicationController
      layout nil

      def create
        @attachment = Attachment.new(file: params[:file],
                                     attachable: find_attachable)
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

      private
      def find_attachable
        if params.has_key? :attachable_id
          return params[:attachable_type].
            classify.constantize.find(params[:attachabl_id])
        end
        params.each do |n,v|
          if n =~ /(.+)_id$/
            return $1.classify.constantize.find(v)
          end
        end
        raise ActiveRecord::RecordNotFound.new("No attachable specified")
      end
    end
  end
end
