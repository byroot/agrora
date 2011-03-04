def logged_in_as(user)
  controller.send(:current_user=, user)
end