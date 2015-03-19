# Plugin's routes
# See: http://guides.rubyonrails.org/routing.html

resources :projects do
	resources :testcases
end

get '/issues/:issue_id/progress', :to => 'testcases#progress'
get '/projects/:project_identifier/jenkins_update', :to => 'jenkinshandler#updatecases', as: 'jenkins_update'
get '/projects/:project_id/testcases/:id/toggle', :to => 'testcases#toggle'

