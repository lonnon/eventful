module Eventful
  module PageExtensions
    def self.included(base)
      base.extend(ClassMethods)
      base.class_eval do
        class << self
          alias_method_chain :new_with_defaults, :events
        end
      end
    end
    
    module ClassMethods
      def new_with_defaults_with_events(config = Radiant::Config)
        returning(new_with_defaults_without_events(config)) do |page|
          page.class_name = 'EventPage' if page.parent.class_name == 'EventListPage'
        end
      end
    end
  end
end
