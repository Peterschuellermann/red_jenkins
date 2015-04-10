require 'redmine'
require_dependency 'red_jenkins/hooks/hooks'

Redmine::Plugin.register :red_jenkins do
    name 'Red Jenkins plugin'
    author 'Peter Schüllermann'
    description 'This plugin includes Jenkins in Redmine'
    version '1.0.1'
    #url ''
    author_url 'https://github.com/Pepperrs/red_jenkins'

    permission :testcases, { :testcases => [:index]}, :public => true
    menu :project_menu, :testcases,
        { :controller => 'testcases', :action => 'index' },
        :caption => 'Testcases',
        :after => :new_issue,
        :param => :project_id

    settings :default => {
        'red_jenkins_server_url' => nil,
        'red_jenkins_server_ip' => nil,
        'red_jenkins_server_port' => nil,
        'red_jenkins_proxy_ip' => nil,
        'red_jenkins_proxy_port' => nil,
        'red_jenkins_jenkins_path' => "/",
        'red_jenkins_username' => nil,
        'red_jenkins_password' => nil,
        'red_jenkins_password_base64' => nil,
        'red_jenkins_log_location' => nil,
        'red_jenkins_log_level' => 1,
        'red_jenkins_timeout' => 120,
        'red_jenkins_http_open_timeout' => 120,
        'red_jenkins_http_read_timeout' => 120,
        'red_jenkins_ssl' => false,
        'red_jenkins_follow_redirects' => false,
        'red_jenkins_identity_file' => nil,
        'red_jenkins_cookies' => nil
    },
        :partial => 'settings/red_jenkins_settings'

end
