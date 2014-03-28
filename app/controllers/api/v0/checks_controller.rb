module Api
  module V0
    class ChecksController < ApplicationController
      def create
        params[:check][:run] =  Run.find(params[:run_id])
        @check = Check.create(params[:check])
        if @check.save
          render '_check', {
            locals: {check: @check},
            format: :json,
            status: :created,
            location: "/api/v0/checks/#{@check.id}",
          }
        end
      end

      def index
        if !params[:run_id].blank?
          run = Run.find(params[:run_id])
          @checks = run.checks
        else
          @checks = Check.all
        end
      end

      def show
        begin
          @check = Check.find(params[:id])
        rescue ActiveRecord::RecordNotFound
          render '_error', format: :json, locals: {errors: ['Record not found']}
          return
        end
        render '_check', format: :json, locals: {check: @check}
      end
    end
  end
end
