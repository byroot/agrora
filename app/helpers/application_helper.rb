module ApplicationHelper
  
  def decorate(instance, options={})
    name = instance.class.name.underscore.to_sym
    render "decorators/#{name}", {name => instance}.merge(options)
  end
  
  def html_class(instance)
    instance.class.name.underscore.dasherize
  end
  
  def body_tag
    tag(:body, {:id => html_class(controller), :class => "action-#{params[:action]}"}, true)
  end
  
end
