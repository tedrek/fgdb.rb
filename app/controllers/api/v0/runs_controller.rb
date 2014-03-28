module Api
  module V0
    class RunsController < ApplicationController
      # **** GET /api/runs
      # JSON list of runs
      def index
        @runs = Run.all
      end

      # **** GET /api/runs/:id
      # JSON representation of a run
      def show
        begin
          @run = Run.find(params[:id])
        rescue ActiveRecord::RecordNotFound
          render '_error', format: :json, locals: {errors: ['Record not found']}
          return
        end
        render '_run', format: :json, locals: {run: @run}
      end

      # **** POST /api/runs
      # Create a new run, 201 with location on success
      # Requires:
      # - run[device_name]: The device name during this run
      # - run[drive_id]: The id of the drive which this run is associated with
      def create
        params[:run][:drive_id] = params[:drive_id] if params.has_key? :drive_id
        params[:run][:start_time] ||= Time.zone.now
        params[:run][:result] ||= 'In progress'
        @run = Run.create(params[:run])
        if @run.save
          render '_run', {
            locals: {run: @run},
            format: :json,
            status: :created,
            location: "/api/v0/runs/#{@run.id}",
          }
        else
          render('api/v0/json/_error',
                 status: :bad_request,
                 locals: {errors: @run.errors.to_a})
        end
      end

      # **** PUT /api/runs/:id
      # Update a run, may only update the result from InProgress.  Sets the
      # end_time.
      def update
        params[:run][:end_time] ||= Time.zone.now
        @run = Run.find(params[:id])
        @run.update_attributes!(params[:run])
        render '_run', format: :json, locals: {run: @run}
      end

      # **** DELETE /api/runs/:id
      def destroy
        raise NotImplementedError.new "Destroying runs not implemented"
      end

      # **** GET /api/runs/:id/checks
      # JSON list of checks in a given run

      # **** POST /api/runs/:id/checks
      # Create a new check in a run, 201 with location

      # Requires:
      # - check_code
      # - check_name
      # - passed
      # - sequence_num
      # - status
      # - start_time
      # - end_time
    end
  end
end
