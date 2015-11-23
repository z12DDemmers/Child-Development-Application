require 'test_helper'

class AssessmentControllerTest < ActionController::TestCase
  test "should get gross_motor" do
    get :gross_motor
    assert_response :success
  end

end
