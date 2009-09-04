require File.dirname(__FILE__) + '/../spec_helper'

describe EventPage do
  before(:each) do
    @event_page = EventPage.new
    @event_page.title = "An upcoming event"
    @event_page.breadcrumb = "An upcoming event"
    @event_page.slug = "an-upcoming-event"
  end

  describe "without any frippery" do
    it "should be valid" do
      @event_page.should be_valid
    end
  end
  
  describe "with valid start and end dates" do
    before do
      @event_page.event_start = Time.now
      @event_page.event_end = Time.now + 2.days
    end
  
    it "should be valid" do
      @event_page.should be_valid
    end
  end

  describe "with end date before start date" do
    before do
      @event_page.event_start = Time.now
      @event_page.event_end = Time.now - 2.days
    end

    it "should not be valid" do
      @event_page.should_not be_valid
    end
  end
  
  describe "with end date but no start date" do
    before do
      @event_page.event_end = Time.now
    end

    it "should not be valid" do
      @event_page.should_not be_valid
    end
  end
end
