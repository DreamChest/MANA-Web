require 'test_helper'

class OpmlUploadersControllerTest < ActionController::TestCase
  setup do
    @opml_uploader = opml_uploaders(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:opml_uploaders)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create opml_uploader" do
    assert_difference('OpmlUploader.count') do
      post :create, opml_uploader: {  }
    end

    assert_redirected_to opml_uploader_path(assigns(:opml_uploader))
  end

  test "should show opml_uploader" do
    get :show, id: @opml_uploader
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @opml_uploader
    assert_response :success
  end

  test "should update opml_uploader" do
    patch :update, id: @opml_uploader, opml_uploader: {  }
    assert_redirected_to opml_uploader_path(assigns(:opml_uploader))
  end

  test "should destroy opml_uploader" do
    assert_difference('OpmlUploader.count', -1) do
      delete :destroy, id: @opml_uploader
    end

    assert_redirected_to opml_uploaders_path
  end
end
