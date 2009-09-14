require File.dirname(__FILE__) + '/../spec_helper'

describe 'Eventful Tags' do
  dataset :event_pages
  
  describe "<r:events:each>" do
    it "should return a list of future event pages" do
      markup = "<r:events:each><r:title /> </r:events:each>"
      
      expected = "Normal Event Event 2 Event 3 Event 4 Event 5 Event 6 All-day Event No End Specified Event "
      
      pages(:event_list).should render(markup).as(expected)
    end
  end
  
  describe "<r:events:each order='asc'>" do
    it "should return future event pages in chronological order" do
      markup = "<r:events:each order='asc'><r:title /> </r:events:each>"
      
      expected = "Normal Event Event 2 Event 3 Event 4 Event 5 Event 6 All-day Event No End Specified Event "
      
      pages(:event_list).should render(markup).as(expected)
    end
  end
  
  describe "<r:events:each order='desc'>" do
    it "should return future event pages in reverse chronological order"
  end
  
  describe "<r:events:each limit='3'>" do
    it "should return the first three future event pages"
  end
  
  describe "<r:events:each offset='2'>" do
    it "should return future event pages starting with the second page"
  end
  
  describe "<r:events:each by='title'>" do
    it "should return future event pages ordered by title"
  end
  
  describe "<r:events:each from='date' to='date'>" do
    it "should return event pages between the given dates"
  end
  
  describe "<r:events:each past='true'>" do
    it "should include event pages prior to current date and time"
  end
  
  describe "<r:events:date>" do
    it "should return the start date for the event page"
  end
  
  describe "<r:events:datetime>" do
    it "should return the start date and time for the event page"
  end
  
  describe "<r:events:start>" do
    it "should return the start date for the event page"
  end
  
  describe "<r:events:start:date>" do
    it "should return the start date for the event page"
  end
  
  describe "<r:events:start:time>" do
    it "should return the start time for the event page"
  end
  
  describe "<r:events:start:datetime>" do
    it "should return the start date and time for the event page"
  end
  
  describe "<r:events:end>" do
    it "should return the end date for the event page"
  end
  
  describe "<r:events:end:date>" do
    it "should return the end date for the event page"
  end
  
  describe "<r:events:end:time>" do
    it "should return the end time for the event page"
  end
  
  describe "<r:events:end:datetime>" do
    it "should return the end date and time for the event page"
  end
end
