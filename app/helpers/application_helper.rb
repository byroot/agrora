module ApplicationHelper
  
  def decorate(instance)
    name = instance.class.name.underscore.to_sym
    render "decorators/#{name}", {name => instance}
  end
  
  def html_class(instance)
    instance.class.name.underscore.dasherize
  end
  
end
