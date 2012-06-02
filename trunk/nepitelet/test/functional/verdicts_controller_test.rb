require File.dirname(__FILE__) + '/../test_helper'
require 'verdicts_controller'

# Re-raise errors caught by the controller.
class VerdictsController; def rescue_action(e) raise e end; end

class VerdictsControllerTest < Test::Unit::TestCase
  def setup
    @controller = VerdictsController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  # Replace this with your real tests.
  def test_truth
    assert true
  end
end
