# this module depend of authentification module
module Authorization
  
  module ControllerExtension
  
    PermissionRequired = Class.new(Exception)
  
    def self.included(base)
      base.rescue_from PermissionRequired, :with => :access_denied 
      base.helper_method :logged_in?, :admin?
      base.send(:include, InstanceMethods)
      base.extend(ClassMethods)
    end
  
    module ClassMethods
    
      def require_permission(permission, options={})
        before_filter(options) do |controller|
          controller.require_permission(permission)
        end
      end
    
    end
  
    module InstanceMethods
    
      protected
    
      def require_permission(permission)
        raise PermissionRequired.new unless current_user.authorized_to?(permission)
      end

      def access_denied
        redirect_to new_session_url(:redirect => request.path)
      end

    end
    
  end
  
  module ModelMixin
    
    def authorized_to?(permission, *args, &block)
      send("can_#{permission}?", *args, &block)
    end
    
    def can_view_admin?
      activated? && admin?
    end
    
    def can_create_message?
      activated?
    end
    
  end
  
end
