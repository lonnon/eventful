class EventPagesDataset < Dataset::Base
  uses :home_page
  
  def load
    create_page "Event List" do
      create_page "Normal Event",
                  :class_name  => 'EventPage',
                  :event_start => Time.now + 1.day,
                  :event_end   => Time.now + 1.day + 2.hours
      (2..6).each do |event|
        create_page "Event #{event}",
                    :class_name  => 'EventPage',
                    :event_start => Time.now + event.days,
                    :event_end   => Time.now + event.days + 2.hours
      end
      create_page "Old Event",
                  :class_name  => 'EventPage',
                  :event_start => Time.now - 2.days,
                  :event_end   => Time.now - 2.days + 2.hours
      create_page "All-day Event",
                  :class_name  => 'EventPage',
                  :event_start => Time.now + 7.days
      create_page "No End Specified Event",
                  :class_name  => 'EventPage',
                  :event_start => Time.now + 8.days
      create_page "Draft Event",
                  :class_name  => 'EventPage',
                  :event_start => Time.now + 9.days,
                  :status_id   => Status['Draft'].id
    end
  end
end
