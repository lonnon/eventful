module EventfulTags
  include Radiant::Taggable

  tag 'events' do |tag|
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
    result = []
    children = tag.locals.children
    events = children.find(:all,
      :conditions => {:class_name => 'EventPage'})
    events.each_with_index do |event, i|
      tag.locals.child = event
      tag.locals.page = event
      tag.locals.first_child = i == 0
      tag.locals.last_child = i == events.length - 1
      results << tag.expand
    end
    result
  end
end
