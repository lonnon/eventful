class EventPage < Page
  validate :must_have_chronological_event_dates,
           :must_have_start_date_if_end_date_exists

protected
  def must_have_chronological_event_dates
    errors.add(:event_start, "must be later than event end") if (!event_start.nil? && !event_end.nil? && event_end < event_start)
  end
  
  def must_have_start_date_if_end_date_exists
    errors.add(:event_start, "must exist if event end date is filled in") if (!event_end.nil? && event_start.nil?)
  end
end
