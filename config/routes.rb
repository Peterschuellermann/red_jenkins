# Plugin's routes
# See: http://guides.rubyonrails.org/routing.html

resources :projects do
	resources :testcases
end

get '/issues/:issue_id/progress', :to => 'testcases#progress'

get 'jenkins_update', :to => 'jenkinshandler#updatecases'

