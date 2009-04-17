# Add your custom routes here.  If in config/routes.rb you would 
# add <tt>map.resources</tt>, here you would add just <tt>resources</tt>

# resources :rails_contents

# session
logout '/admin/logout', :controller => 'admin/sessions', :action => 'destroy'
login '/admin/login', :controller => 'admin/sessions', :action => 'new'
root :controller => 'cms', :action => 'show', :url => 'home'

# admin part
namespace :admin do |admin|
  admin.root :controller => 'dashboard'
  admin.resource :session
  admin.resources :account
  admin.resources :admins
  admin.resources :roles
  admin.resources :rights
  admin.resources :translations
  
  connect 'admin/*model/untranslated', :controller => 'admin/translations', :action => 'list_untranslated'
  connect 'admin/*model/translate/:id', :controller => 'admin/translations', :action => 'edit_dynamic'
  connect 'admin/*model/update_translation/:id', :controller => 'admin/translations', :action => 'update_dynamic'
  connect ':controller/:action/:id'
end

# cms pages
connect '/*sections/:url', :controller => 'cms', :action => 'show'
connect ':url', :controller => 'cms', :action => 'show'
