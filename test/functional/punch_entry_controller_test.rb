require 'test_helper'

class PunchEntryControllerTest < ActionController::TestCase
  fixtures :contacts

  test "the default action works" do
    get :index
    assert_response :success
  end

  test "signing in with a volunteer ID" do
    assert_difference 'PunchEntry.count' do
      post :punch, volunteer_id: 17, commit: 'Sign in'
    end
  end

  test "signing in with a volunteer name" do
    assert_difference 'PunchEntry.count' do
      post(:punch,
           first_name: 'Charles',
           last_name: 'McGeneneen',
           commit: 'Sign in')
    end
  end

  test "signing out with a volunteer ID" do
    assert_nil PunchEntry.open.where(contact_id: 17).first, "no open entries"
    p = PunchEntry.new
    p.contact_id = 17
    p.in_time = Time.now - 1020 # 17 minutes ago
    p.save!
    id = p.id
    post :punch, volunteer_id: 17, commit: 'Sign out', station: 42
    p = PunchEntry.find(id)
    assert_not_nil p
    assert_not_nil p.out_time
    assert p.in_time <= p.out_time
    assert_not_nil p.volunteer_task
    assert_equal p.volunteer_task.duration, 0.25, 'Round duration to 15 minutes'
  end

  test "signing out without sign in fails" do
    post :punch, volunteer_id: 17, commit: 'Sign out', station: 42
    assert_response :redirect
    assert_equal flash[:message],
                 'Error signing out: Charles McGeneneen is not signed in'
  end
end
