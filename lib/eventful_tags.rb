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
    order_string = ''
    if self.attributes.keys.include?(by)
      order_string << by
    else
      raise TagError.new("'by' attribute of 'each' tag must be set to a valid field name")
    end
    options[:order] = order_string
    
    options[:conditions] = "class_name = 'EventPage' AND event_start >= '#{Time.now.to_s(:db)}'"
    
    options
  end
end
