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
      start_date = Time.now + 2.days - 30.minutes
      end_date =   Time.now + 6.days + 30.minutes
      markup = "<r:events:each from='#{start_date}'" +
               " to='#{end_date}'><r:title /> </r:events:each>"
      
      expected = "Event 2 Event 3 Event 4 Event 5 Event 6 "
      
      pages(:event_list).should render(markup).as(expected)
    end
  end
  
  describe "<r:events:each from='date'>" do
    it "should return event pages starting from the given date" do
      start_date = Time.now + 3.days - 30.minutes
      markup = "<r:events:each from='#{start_date}'" +
               "><r:title /> </r:events:each>"
      
      expected = "Event 3 Event 4 Event 5 Event 6 All-day Event No End Specified Event "
      
      pages(:event_list).should render(markup).as(expected)
    end
  end
  
  describe "<r:events:each to='date'>" do
    it "should return event pages up to the given date" do
      end_date = Time.now + 4.days + 30.minutes
      markup = "<r:events:each to='#{end_date}'" +
               "><r:title /> </r:events:each>"
               
      expected = "Normal Event Event 2 Event 3 Event 4 "
      
      pages(:event_list).should render(markup).as(expected)
    end
  end
  
  describe "<r:events:each from='nonsense'>" do
    it "should return a TagError exception" do
      markup = "<r:events:each from='wibble'>" +
               "<r:title /> </r:events:each>"
               
      pages(:event_list).should render(markup).with_error("'from' attribute of 'each' tag must be set to a valid date")
    end
  end
  
  describe "<r:events:each to='nonsense'>" do
    it "should return a TagError exception" do
      markup = "<r:events:each to='wibble'>" +
               "<r:title /> </r:events:each>"
      
      pages(:event_list).should render(markup).with_error("'to' attribute of 'each' tag must be set to a valid date")
    end
  end
  
  describe "<r:events:each from='date' to='before_date'>" do
    it "should return a TagError exception" do
      start_date = Time.now + 2.days
      end_date   = Time.now
      markup = "<r:events:each from='#{start_date}'" +
               " to='#{end_date}'><r:title /></r:events:each>"
      
      pages(:event_list).should render(markup).with_error("'from' attribute of 'each' tag must come before 'to' attribute")
    end
  end
  
  describe "<r:events:each past='true'>" do
    it "should include event pages prior to current date and time" do
      markup = "<r:events:each past='true'><r:title /> </r:events:each>"
      
      expected = "Old Event Normal Event Event 2 Event 3 Event 4 Event 5 Event 6 All-day Event No End Specified Event "
      
      pages(:event_list).should render(markup).as(expected)
    end
  end
  
  describe "<r:events:each status='all'>" do
    it "should return event pages, including those with Draft status" do
      markup = "<r:events:each status='all'><r:title /> </r:events:each>"
      
      expected = "Normal Event Event 2 Event 3 Event 4 Event 5 Event 6 All-day Event No End Specified Event Draft Event "
      
      pages(:event_list).should render(markup).as(expected)
    end
  end
  
  describe "<r:events:each status='published'>" do
    it "should return only published event pages" do
      markup = "<r:events:each status='published'><r:title /> </r:events:each>"
      
      expected = "Normal Event Event 2 Event 3 Event 4 Event 5 Event 6 All-day Event No End Specified Event "
      
      pages(:event_list).should render(markup).as(expected)
    end
  end
  
  describe "<r:date /> on an EventPage" do
    it "should return the start date for the event page" do
      markup = "<r:date />"
      
      expected = "#{pages(:normal_event).event_start.strftime '%A, %B %d, %Y'}"

      pages(:normal_event).should render(markup).as(expected)
    end
  end
  
  describe "<r:date /> on a regular Page" do
    it "should return the published or created date for the page" do
      markup = "<r:date />"
      
      expected = "#{pages(:home).published_at.strftime '%A, %B %d, %Y'}"
      
      pages(:home).should render(markup).as(expected)
    end
  end
  
  describe "<r:date format='%Y-%m-%d' />" do
    it "should return the start date for the event page, formatted according to the 'format' attribute" do
      markup = "<r:date format='%Y-%m-%d' />"
      
      expected = "#{pages(:normal_event).event_start.strftime '%Y-%m-%d'}"
      
      pages(:normal_event).should render(markup).as(expected)
    end
  end
  
  describe "<r:date for='event_end' />" do
    it "should return the end date for the event page" do
      markup = "<r:date for='event_end' />"
      
      expected = "#{pages(:normal_event).event_end.strftime '%A, %B %d, %Y'}"
      
      pages(:normal_event).should render(markup).as(expected)
    end
  end
end
