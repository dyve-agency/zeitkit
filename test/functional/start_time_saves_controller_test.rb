require 'test_helper'

class StartTimeSavesControllerTest < ActionController::TestCase
  setup do
    @start_time_safe = start_time_saves(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:start_time_saves)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create start_time_safe" do
    assert_difference('StartTimeSave.count') do
      post :create, start_time_safe: { start_time: @start_time_safe.start_time, user_id: @start_time_safe.user_id }
    end

    assert_redirected_to start_time_safe_path(assigns(:start_time_safe))
  end

  test "should show start_time_safe" do
    get :show, id: @start_time_safe
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @start_time_safe
    assert_response :success
  end

  test "should update start_time_safe" do
    put :update, id: @start_time_safe, start_time_safe: { start_time: @start_time_safe.start_time, user_id: @start_time_safe.user_id }
    assert_redirected_to start_time_safe_path(assigns(:start_time_safe))
  end

  test "should destroy start_time_safe" do
    assert_difference('StartTimeSave.count', -1) do
      delete :destroy, id: @start_time_safe
    end

    assert_redirected_to start_time_saves_path
  end
end
