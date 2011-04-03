# (c) Greg Moreno 2011-01-27 
# http://gregmoreno.ca/preventing-model-explosion-via-rails-serialization/

module ActiveRecord
  module HasSerializedAssociation
  	def self.included(base)
  		base.send :extend, ClassMethods
  		Rails.logger.debug "---- HasSerialized loaded ----"
  	end
 
    module ClassMethods
 
      def has_serialized(serialized, serialized_accessors={}) 
        serialize serialized, serialized_accessors.class
 
        serialized_attr_accessor serialized, serialized_accessors
        default_serialized_attr  serialized, serialized_accessors
      end
 
      # Creates the accessors
      def serialized_attr_accessor(serialized, accessors)
        accessors.keys.each do |k|
          define_method("#{k}") do
            self[serialized] && self[serialized][k]
          end
 
          define_method("#{k}=") do |value|
            self[serialized][k] = value
          end
        end
      end
 
      # Sets the default value of the serialized field
      def default_serialized_attr(serialized, accessors)
        method_name =  "set_default_#{serialized}"
        after_initialize method_name
 
        define_method(method_name) do
          self[serialized] = accessors if self[serialized].nil?
        end
      end
    end
  end
end