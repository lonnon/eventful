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
    it "should return future event pages in reverse chronological order" do
      markup = "<r:events:each order='desc'><r:title /> </r:events:each>"
      
      expected = "No End Specified Event All-day Event Event 6 Event 5 Event 4 Event 3 Event 2 Normal Event "
      
      pages(:event_list).should render(markup).as(expected)
    end
  end
  
  describe "<r:events:each limit='3'>" do
    it "should return the first three future event pages" do
      markup = "<r:events:each limit='3'><r:title /> </r:events:each>"
      
      expected = "Normal Event Event 2 Event 3 "
      
      pages(:event_list).should render(markup).as(expected)
    end
  end
  
  describe "<r:events:each offset='2'>" do
    it "should return future event pages starting with the third page" do
      pending
      markup = "<r:events:each offset='2'><r:title /> </r:events:each>"
      
      expected = "Event 4 Event 5 Event 6 All-day Event No End Specified Event "
      
      pages(:event_list).should render(markup).as(expected)
    end
  end
  
  describe "<r:events:each by='title'>" do
    it "should return future event pages ordered by title" do
      markup = "<r:events:each by='title'><r:title /> </r:events:each>"
      
      expected = "All-day Event Event 2 Event 3 Event 4 Event 5 Event 6 No End Specified Event Normal Event "
      
      pages(:event_list).should render(markup).as(expected)
    end
  end
  
  describe "<r:events:each from='date' to='date'>" do
    it "should return event pages between the given dates" do
      start_date = (Time.now + 2.days - 30.minutes).to_s(:db)
      end_date =   (Time.now + 6.days + 30.minutes).to_s(:db)
      
      markup = "<r:events:each from='#{start_date}'" +
               " to='#{end_date}'><r:title /> </r:events:each>"
      
      expected = "Event 2 Event 3 Event 4 Event 5 Event 6 "
      
      print "start_date: #{pages(:event_2).event_start.to_s(:db)}\n"
      print "end_date:   #{pages(:event_6).event_start.to_s(:db)}\n"
      pages(:event_list).should render(markup).as(expected)
    end
  end
  
  describe "<r:events:each from='date'>" do
    it "should return event pages starting from the given date"
  end
  
  describe "<r:events:each to='date'>" do
    it "should return event pages up to the given date"
  end
  
  describe "<r:events:each from='nonsense'" do
    it "should return a TagError exception"
  end
  
  describe "<r:events:each to='nonsense'" do
    it "should return a TagError exception"
  end
  
  describe "<r:events:each from='date' to='before_date'>" do
    it "should return a TagError exception"
  end
  
  describe "<r:events:each past='true'>" do
    it "should include event pages prior to current date and time" do
      markup = "<r:events:each past='true'><r:title /> </r:events:each>"
      
      expected = "Old Event Normal Event Event 2 Event 3 Event 4 Event 5 Event 6 All-day Event No End Specified Event "
      
      pages(:event_list).should render(markup).as(expected)
    end
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
