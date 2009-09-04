require File.expand_path(File.dirname(__FILE__) + "/../test_helper")

class EventPageTest < ActiveSupport::TestCase
  context "An EventPage instance" do
    setup do
      @event_page = EventPage.new
      @event_page.title = "An upcoming event"
      @event_page.breadcrumb = "An upcoming event"
      @event_page.slug = "an-upcoming-event"
    end
    
    context "without extra frippery" do
      should "be valid" do
        assert @event_page.valid?
      end
    end
    
    context "with valid start and end dates" do
      should "be valid" do
        @event_page.event_start = Time.now + 2.days
        @event_page.event_end = Time.now + 4.days
        
        assert @event_page.valid?
      end
    end
    
    context "with end date before start date" do
      should "not be valid" do
        @event_page.event_start = Time.now + 2.days
        @event_page.event_end = Time.now
        
        assert !@event_page.valid?
      end
    end
    
    context "with end date but no start date" do
      should "not be valid" do
        @event_page.event_end = Time.now
        
        assert !@event_page.valid?
      end
    end
  end
end