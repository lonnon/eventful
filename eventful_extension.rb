# Uncomment this if you reference any of your controllers in activate
# require_dependency 'application'

class EventfulExtension < Radiant::Extension
  version "1.0"
  description "Support for upcoming event pages"
  url "http://github.com/lonnon/eventful"
  
  define_routes do |map|
    map.with_options(:controller => "admin/pages") do |page|
      page.update_event_ui "/admin/pages/:id/update_event_ui",
        :action => 'update_event_ui'
    end
  end
  
  def activate
    admin.page.edit.add(:form, 'event_dates',
      :after => 'edit_extended_metadata')
    Admin::PagesController.send :include,
      Eventful::PagesControllerExtensions
    Page.send :include, Eventful::PageExtensions
    Page.send :include, EventfulTags
  end
  
  def deactivate
    # admin.tabs.remove "Eventful"
  end
  
end
