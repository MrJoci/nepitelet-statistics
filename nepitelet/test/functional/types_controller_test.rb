require File.dirname(__FILE__) + '/../test_helper'
require 'types_controller'

# Re-raise errors caught by the controller.
class TypesController; def rescue_action(e) raise e end; end

class TypesControllerTest < Test::Unit::TestCase
  def setup
    @controller = TypesController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  # Replace this with your real tests.
  def test_truth
    assert true
  end
end
