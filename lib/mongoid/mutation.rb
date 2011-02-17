module Mongoid
  
  module Mutation
    
    def as(klass, extra_attributes={})
      copy_state(klass.new(attributes_for(klass, extra_attributes))).tap do |mutation|
        mutation.send(:modifications).merge!(modifications_for(klass, extra_attributes))
      end
    end
    
    def as!(klass, extra_attributes={})
      mutation = as(klass, extra_attributes)
      mutation.save!
      klass.find(self._id)
    end
    
    private
    
    def copy_state(mutation)
      mutation.id = self._id
      mutation.new_record = new_record?
      if self.embedded?
        mutation._parent = self._parent
        mutation._index = self._index
      end
      mutation
    end
    
    def attributes_for(klass, extra_attributes)
      shared_attributes = self.attributes.slice(*klass.fields.keys)
      shared_attributes.merge(extra_attributes)
    end
    
    def lost_fields(klass)
      self.class.fields.keys - klass.fields.keys
    end
    
    def modifications_for(klass, extra_attributes)
      extra_attributes = extra_attributes.except('_type', '_id')
      {'_type' => [self._type, klass.name]}.tap do |modifications|
        lost_fields(klass).each do |field|
          modifications[field] = [self.read_attribute(field), nil]
        end
        extra_attributes.each do |field, value|
          modifications[field] = [nil, value] if klass.fields.keys.include?(field)
        end
      end
    end
    
  end
  
end