require File.dirname(__FILE__) + '/../test_helper'

class EventTest < Test::Unit::TestCase
  fixtures :events

  # Replace this with your real tests.
  def test_normal
    events = Event.find_public_evnet(10)
    assert_equal(events.size, 2)
  end
  
  def test_offset
    events = Event.find_public_evnet(1, 1)
    assert_equal(events.size, 1)
  end
  
  def test_public_event_count
    events = Event.find_by_public_event_count
    assert_equal(events.count, "2")
  end
  
  def test_delivery
    events = Event.find_by_delivery
    assert_equal(events.size, 1)
    assert_equal(events.first.html,'test_2')
  end
end
