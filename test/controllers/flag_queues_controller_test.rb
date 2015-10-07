require 'test_helper'

class FlagQueuesControllerTest < ActionController::TestCase
  setup do
    @flag_queue = flag_queues(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:flag_queues)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create flag_queue" do
    assert_difference('FlagQueue.count') do
      post :create, flag_queue: { name: @flag_queue.name }
    end

    assert_redirected_to flag_queue_path(assigns(:flag_queue))
  end

  test "should show flag_queue" do
    get :show, id: @flag_queue
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @flag_queue
    assert_response :success
  end

  test "should update flag_queue" do
    patch :update, id: @flag_queue, flag_queue: { name: @flag_queue.name }
    assert_redirected_to flag_queue_path(assigns(:flag_queue))
  end

  test "should destroy flag_queue" do
    assert_difference('FlagQueue.count', -1) do
      delete :destroy, id: @flag_queue
    end

    assert_redirected_to flag_queues_path
  end
end
