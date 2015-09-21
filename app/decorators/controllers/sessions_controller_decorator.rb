Admin::SessionsController.class_eval do
  before_action :set_proper_register_param

  def register
    not_found
  end

  private 

  def set_proper_register_param
    if current_site.get_option('has_create_account') != true
      current_site.set_option('has_create_account',false)    
    end
  end
end