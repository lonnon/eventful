module EventfulTags
  include Radiant::Taggable
  
  class TagError < StandardError; end

  tag 'events' do |tag|
    tag.locals.children = tag.locals.page.children
    tag.expand
  end

  desc %{
    Cycles through each of the event children of the current page.
    Inside this tag, all page attribute tags are mapped to the current
    child event page.
    
    *Usage:*
    
    <pre><code><r:events:each [limit="number"] [by="attribute"]
    [order="asc|desc"] [status="draft|reviewed|published|hidden|all"]
    [past="false"] [from="start_date"] [to="end_date"]>
     ...
    </r:children:each>
    </code></pre>
  }
  tag 'events:each' do |tag|
    options = events_find_options(tag)
    result = []
    events = tag.locals.children.find(:all, options)
    events.each_with_index do |event, i|
      tag.locals.child = event
      tag.locals.page = event
      tag.locals.first_child = i == 0
      tag.locals.last_child = i == events.length - 1
      result << tag.expand
    end
    result
  end
  
  desc %{
    Renders the date based on the current page. On a regular page, it
    defaults to the date the page was published or created. On an event
    page, it defaults to the start date of the event. The format
    attribute uses the same formating codes used by the Ruby @strftime@
    function. By default it's set to @%A, %B %d, %Y@. The @for@
    attribute selects which date to render.  Valid options are
    @published_at@, @created_at@, @updated_at@, @event_start@,
    @event_end@, and @now@. @now@ renders the current date/time,
    regardless of the page.

    *Usage:*

    <pre><code><r:date [format="%A, %B %d, %Y"] [for="published_at|event_start"]/></code></pre>
  }
  tag 'date' do |tag|
    page = tag.locals.page
    format = (tag.attr['format'] || '%A, %B %d, %Y')
    time_attr = tag.attr['for']
    date = if time_attr
      case
      when time_attr == 'now'
        Time.now
      when ['published_at', 'created_at', 'updated_at',
            'event_start', 'event_end'].include?(time_attr)
        page[time_attr]
      else
        raise TagError, "Invalid value for 'for' attribute."
      end
    else
      if page.class_name == 'EventPage'
        page.event_start
      else
        page.published_at || page.created_at
      end
    end
    adjust_time(date).strftime(format)
  end

private

  def events_find_options(tag)
    attr = tag.attr.symbolize_keys
    options = {}
    
    by = (attr[:by] || 'event_start').strip
    order = (attr[:order] || 'asc').strip
    order_string = ''
    if self.attributes.keys.include?(by)
      order_string << by
    else
      raise TagError.new("'by' attribute of 'each' tag must be set to a valid field name")
    end
    if order =~ /^(asc|desc)$/i
      order_string << " #{$1.upcase}"
    else
      raise TagError.new(%{'order' attribute of 'each' tag must be set to either "asc" or "desc"})
    end
    options[:order] = order_string
    
    options[:conditions] = "class_name = 'EventPage'"
    past = (attr[:past] || 'false').strip
    from = (attr[:from]) ? (attr[:from]).strip : nil
    to = (attr[:to]) ? attr[:to].strip : nil
    time_condition = ""
    start_date = Time.now
    end_date = nil
    if from
      begin
        Date.parse(from)
        start_date = Time.parse(from)
        time_condition << " AND event_start >= '#{start_date.to_s(:db)}'"
      rescue ArgumentError
        raise TagError.new("'from' attribute of 'each' tag must be set to a valid date")
      end
    else
      if past != 'true'
        time_condition << " AND event_start >= '#{start_date.to_s(:db)}'"
      end
    end
    if to
      begin
        Date.parse(to)
        end_date = Time.parse(to)
        time_condition << " AND event_start <= '#{end_date.to_s(:db)}'"
      rescue ArgumentError
        raise TagError.new("'to' attribute of 'each' tag must be set to a valid date")
      end
    end
    if end_date && start_date > end_date
      raise TagError.new("'from' attribute of 'each' tag must come before 'to' attribute")
    end
    options[:conditions] << time_condition

####
    status = (attr[:status] || ( dev?(tag.globals.page.request) ? 'all' : 'published')).downcase
    stat_condition = ""
    unless status == 'all'
      stat = Status[status]
      unless stat.nil?
        stat_condition = " AND virtual = false AND status_id = #{stat.id}"
      else
        raise TagError.new(%{'status' attribute of 'each' tag must be set to a valid status})
      end
    else
      stat_condition = " AND virtual = false"
    end
    options[:conditions] << stat_condition
####
    
    [:limit, :offset].each do |symbol|
      if number = attr[symbol]
        if number =~ /^\d{1,4}$/
          options[symbol] = number.to_i
        else
          raise TagError.new("'#{symbol}' attribute of 'each' tag must be a positive number between 1 and 4 digits")
        end
      end
    end
    
    options
  end
end
