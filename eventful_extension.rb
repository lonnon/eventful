# Uncomment this if you reference any of your controllers in activate
# require_dependency 'application'

class EventfulExtension < Radiant::Extension
  version "1.0"
  description "Describe your extension here"
  url "http://yourwebsite.com/eventful"
  
  # define_routes do |map|
  #   map.namespace :admin, :member => { :remove => :get } do |admin|
  #     admin.resources :eventful
  #   end
  # end
  
  def activate
    admin.page.edit.add(:form, 'event_dates', :after => 'edit_extended_metadata')
  end
  
  def deactivate
    # admin.tabs.remove "Eventful"
  end
  
end
