ActionController::Routing::Routes.draw do |map|
  # The priority is based upon order of creation: first created -> highest priority.
  
  # Sample of regular route:
  # map.connect 'products/:id', :controller => 'catalog', :action => 'view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  # map.purchase 'products/:id/purchase', :controller => 'catalog', :action => 'purchase'
  # This route can be invoked with purchase_url(:id => product.id)

  # You can have the root of your site routed by hooking up '' 
  # -- just remember to delete public/index.html.
  # map.connect '', :controller => "welcome"

  # Allow downloading Web Service WSDL as a file with an extension
  # instead of a file named 'wsdl'
  map.connect ':controller/service.wsdl', :action => 'wsdl'

  map.connect 'category/next_load', :controller => 'category', :action => 'next_load'
  map.connect 'category/:id', :controller => 'category', :action => 'list', :id => ':id', :pagenum => 0
  map.connect 'category/:id/:pagenum', :controller => 'category', :action => 'list', :id => ':id', :pagenum => ':pagenum'

  # Install the default route as the lowest priority.
  map.connect ':controller/:action/:id'
  
  # / でアクセスされたとき
  map.connect '', :controller => 'post', :action => 'top'
  
  map.connect 'privacy', :controller => 'post', :action => 'privacy'
  map.connect 'terms', :controller => 'post', :action => 'terms'
  
  # Mobile用にエレガントに
  map.connect 'm/setup/:id', :controller => 'mobile_auth', :action => 'setup'
  
end
