# Filters added to this controller will be run for all controllers in the application.
# Likewise, all the methods added will be available for all controllers.
class ApplicationController < ActionController::Base
  layout "base_header", :except=> []
  
  def model
    eval(self.class.name.sub("Controller", "").singularize)
  end
  
  def list
    list = self.model.find(:all)
    @list = ListMaker.list(list, self.model.new.attributes.keys)
    render :template => 'application/list'
  end
  
  def show
    render :template => 'application/show'
  end
  
end