require File.dirname(__FILE__) + '/../test_helper'

class ApiMfpsTest < Test::Unit::TestCase

  # Replace this with your real tests.
  def test_truth
    apiMfps = ApiMfps.specific_request("http://bokukoyo.drecom.jp")
    assert true
  end
end