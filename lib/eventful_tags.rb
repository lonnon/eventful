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
    
    <pre><code><r:events:each [offset="number"] [limit="number"] [by="attribute"] [order="asc|desc"]
     [status="draft|reviewed|published|hidden|all"]>
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
    options[:conditions] << time_condition
    
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
