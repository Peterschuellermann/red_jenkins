require 'redmine'
require_dependency 'red_jenkins/hooks/hooks'


Redmine::Plugin.register :red_jenkins do
  name 'Red Jenkins plugin'
  author 'Author name'
  description 'This plugin includes Jenkins in Redmine'
  version '0.0.1'
  url 'http://www.isp.uni-luebeck.de'
  author_url 'https://github.com/Pepperrs/red_jenkins'

  permission :testcases, { :testcases => [:index]}, :public => true
  menu :project_menu, :testcases,
    { :controller => 'testcases', :action => 'index' },
    :caption => 'Testcases',
    :after => :new_issue,
    :param => :project_id
end
