require 'test_helper'

module Api
  module V0
    class DrivesControllerTest < ActionController::TestCase
      def setup
        request.accept = 'application/json'
      end

      test "basic drive CRUD" do
        # Create a drive
        assert_difference 'Drive.count' do
          # Create a drive in standard representation
          post :create, {drive: {
            manufacturer: 'Western Digital',
            model: 'WD5000',
            serial: 'WD-WCAPW2759678',
            size: 500_107_862_016,
            }}

          assert_response 201, 'Successful creation'
        end

        # View a drive in standard representation
        json = JSON.parse(response.body, symbolize_names: true)
        get :show, id: json[:id]
        assert_response :success
        json = JSON.parse(response.body, symbolize_names: true)
        for key in [:id, :manufacturer, :model, :serial, :size] do
          assert json.has_key?(key), "JSON Drive has the key #{key}"
        end

        # Ensure the drive shows up in the listing
        get :index
        listing = JSON.parse(response.body, symbolize_names: true)
        assert listing.any? { |d| d[:id] == json[:id] }

        # Update the drive
        post :update, {
          id: json[:id],
          drive: {
            model: 'WD5000-AAKS-00TMA0'
          }}
        assert_equal Drive.find(json[:id]).model, 'WD5000-AAKS-00TMA0'

        # Delete the drive
        delete :destroy, {id: json[:id]}
        assert_raises ActiveRecord::RecordNotFound do
          Drive.find(json[:id])
        end
      end

      test "creating a drive doesn't create duplicates" do
        drive_info = {
          manufacturer: 'Western Digital',
          model: 'WD5000',
          serial: 'WD-WCAPW2759678',
          size: 500_107_862_016,
        }

        assert_difference 'Drive.count' do
          post :create, {drive: drive_info}
        end
        assert_response 201

        # Ensure posting the same drive twice doesn't create a new drive
        # the second time.
        assert_difference 'Drive.count', 0 do
          post :create, {drive: drive_info}
        end
        assert_response 200
      end

      # For the cases where the device doesn't have SMART information
      test "creating a generic drive" do
        assert_difference 'Drive.count' do
          post :create, {drive: {
            generic: true,
            size: 64_000_000,
            }}
        end

        # Ensure a new drive is created and the previous one isn't returned
        assert_difference 'Drive.count' do
          post :create, {drive: {
            generic: true,
            size: 64_000_000,
            }}
        end
      end
    end
  end
end
