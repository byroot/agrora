module Mongoid
  
  module Mutation
    
    def as(klass, extra_attributes={})
      klass.new(attributes_for(klass, extra_attributes)).tap do |mutation|
        mutation.new_record = new_record?
        mutation.send(:modifications).merge!(modifications_for(klass, extra_attributes))
      end
    end
    
    def as!(klass, extra_attributes={})
      mutation = as(klass, extra_attributes)
      mutation.save!
      klass.find(self._id)
    end
    
    private
    
    def attributes_for(klass, extra_attributes)
      shared_fields = klass.fields.keys + %w(_id)
      shared_attributes = self.attributes.slice(*shared_fields)
      shared_attributes.merge(extra_attributes)
    end
    
    def lost_fields(klass)
      self.class.fields.keys - klass.fields.keys
    end
    
    def modifications_for(klass, extra_attributes)
      {'_type' => [self._type, klass.name]}.tap do |modifications|
        lost_fields(klass).each do |field|
          modifications[field] = [self.read_attribute(field), nil]
        end
      end
    end
    
  end
  
end