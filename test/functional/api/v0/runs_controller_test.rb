require 'test_helper'

module Api
  module V0
    class RunsControllerTest < ActionController::TestCase
      def setup
        request.accept = 'application/json'
      end

      test "basic run CRUD" do
        drive = FactoryGirl.create(:drive)

        assert_difference 'Run.count' do
          # Create a drive in standard representation
          post :create, {
            run: {
              drive_id: drive.id,
              device_name: '/dev/sda'
            }}
          assert_response 201, 'Successful creation'
        end

        # View a run in standard representation
        json = JSON.parse(response.body, symbolize_names: true)
        get :show, id: json[:id]
        assert_response :success
        json = JSON.parse(response.body, symbolize_names: true)
        for key in [:id, :drive, :device_name, :start_time, :end_time, :result] do
          assert json.has_key?(key), "JSON Run has the key #{key}"
        end

        # Ensure the run shows up in the listing
        get :index
        listing = JSON.parse(response.body, symbolize_names: true)
        assert listing.any? { |r| r[:id] == json[:id] }

        # Update the drive
        post :update, {
          id: json[:id],
          run: {
            result: 'Passed'
          }}
        assert_equal Run.find(json[:id]).result, 'Passed'
      end
    end
  end
end
