require 'test_helper'

module Api
  module V0
    class ChecksControllerTest < ActionController::TestCase
      def setup
        request.accept = 'application/json'
      end

      test "basic check CRUD" do
        run = FactoryGirl.create :run
        # Create a check
        assert_difference 'Check.count' do
          # Create a check in standard representation
          post :create, {
            run_id: run.id,
            check: {
              check_code: 'BB',
     #         check_name: 'Bad blocks',
              passed: true,
              sequence_num: 3,
              status: 0,
              start_time: Time.now - 60,
              end_time: Time.now
            }}

          assert_response 201, 'Successful creation'
        end

        # View a check in standard representation
        json = JSON.parse(response.body, symbolize_names: true)
        get :show, id: json[:id]
        assert_response :success
        json = JSON.parse(response.body, symbolize_names: true)
        keys = [:id, :drive, :run, :check_code, :check_name,
                :passed, :sequence_num, :status, :start_time,
                :end_time, :attachments]
        for key in keys do
          assert json.has_key?(key), "JSON Check has the key #{key}"
        end

        # Ensure the check shows up in the listing
        get :index
        listing = JSON.parse(response.body, symbolize_names: true)
        assert listing.any? { |c| c[:id] == json[:id] }

        # **** POST /api/checks/:id/files
        # - Upload a file and attach it to a check,
        #   valid filenames are (stdout.txt, stderr.txt)
      end
    end
  end
end
