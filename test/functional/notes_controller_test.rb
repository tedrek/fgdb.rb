require 'test_helper'

class NotesControllerTest < ActionController::TestCase
  fixtures :contacts, :notes, :systems, :users, :roles_users, :roles

  def setup
    login_as :quentin
  end

  def test_should_get_new
    get :new, :system_id => systems(:one)
    assert_response :success
  end

  def test_should_create_note
    assert_difference('Note.count') do
      post :create, :note => {
        :contact => contacts(:test_contact),
        :system_id => systems(:one).id,
        :body => "Test body",
      }
    end

    assert_redirected_to "/notes/show/#{assigns(:note).id}"
  end

  def test_should_show_note
    get :show, :id => notes(:one).id
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => notes(:one).id
    assert_response :success
  end

  def test_should_update_note
    put :update, :id => notes(:one).id, :note => { :body => "Test body" }
    assert_redirected_to "/notes/show/#{notes(:one).id}"
  end
end
