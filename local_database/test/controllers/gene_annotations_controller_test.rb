require 'test_helper'

class GeneAnnotationsControllerTest < ActionController::TestCase
  setup do
    @gene_annotation = gene_annotations(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:gene_annotations)
  end

  test "should show gene_annotation" do
    get :show, id: @gene_annotation
    assert_response :success
  end

end
