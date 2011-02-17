module ApplicationHelper
  
  def decorate(instance)
    name = instance.class.name.underscore.to_sym
    render "decorators/#{name}", {name => instance}
  end
  
end
