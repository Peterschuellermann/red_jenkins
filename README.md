# RedJenkins
RedJenkins allows you to assign your project's testcases to issues in Redmine. It also allows you to create and run manual tests for your project in Redmine. For a more thorough explaination see `https://github.com/Pepperrs/red_jenkins/wiki/How-to-use-RedJenkins`.

## Installation

**Step 1:** Changing into your plugin directory (e.g. C:\Bitnami\redmine-3.0.0-0\apps\redmine\htdocs\plugins) and clone the project by:

`git clone https://github.com/Pepperrs/red_jenkins.git`

**Step 2:** install missing Gems
run this to install missing gems

`bundle install --no-deployment`

**Step 3:** Changing into your root directory of Redmine (e.g. C:\Bitnami\redmine-3.0.0-0\apps\redmine\htdocs) and run the following command:

`rake redmine:plugins:migrate RAILS_ENV=production`

or

`bundle exec rake redmine:plugins:migrate RAILS_ENV=production`


**Step 4:** Restart Redmine

_See also: http://www.redmine.org/projects/redmine/wiki/Plugins_

