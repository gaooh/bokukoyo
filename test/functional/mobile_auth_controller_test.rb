require File.dirname(__FILE__) + '/../test_helper'
require 'mobile_auth_controller'

# Re-raise errors caught by the controller.
class MobileAuthController; def rescue_action(e) raise e end; end

class MobileAuthControllerTest < Test::Unit::TestCase
  def setup
    @controller = MobileAuthController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  # Replace this with your real tests.
  def test_truth
    assert true
  end
end
