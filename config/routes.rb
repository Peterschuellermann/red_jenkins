# Plugin's routes
# See: http://guides.rubyonrails.org/routing.html

get 'testcases', :to => 'testcases#index'
get 'jenkins_update', :to => 'jenkinshandler#updatecases'

