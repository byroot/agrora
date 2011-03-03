class Anonymous
  
  include Authorization::ModelMixin
  
  def activated?
    false
  end
  
  def admin?
    false
  end
  
end