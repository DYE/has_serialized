require 'attribute_serializer'

ActiveRecord::Base.send :include, ActiveRecord::AttributeSerializer
