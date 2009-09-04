require File.dirname(__FILE__) + '/../spec_helper'

describe EventPage do
  before(:each) do
    @event_page = EventPage.new
  end

  it "should be valid" do
    @event_page.should be_valid
  end
end
