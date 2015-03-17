# Plugin's routes
# See: http://guides.rubyonrails.org/routing.html

resources :testcases 

get '/projects/:project_id/testcases', :to => 'testcases#index'
get '/projects/:project_id/testcases/new', :to => 'testcases#new'

get 'jenkins_update', :to => 'jenkinshandler#updatecases'

