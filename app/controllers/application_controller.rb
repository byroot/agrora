class ApplicationController < ActionController::Base
  protect_from_forgery
  
  include Authentication
  include Authorization::ControllerExtension

  private
  
  def find_or_raise!(scope)
    scope.first or raise Mongoid::Errors::DocumentNotFound.new(scope, scope.selector)
  end

end
