require File.dirname(__FILE__) + '/../test_helper'
require 'brands_controller'

# Re-raise errors caught by the controller.
class BrandsController; def rescue_action(e) raise e end; end

class BrandsControllerTest < Test::Unit::TestCase
  def setup
    @controller = BrandController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  # Replace this with your real tests.
  def test_truth
    assert true
  end
end
