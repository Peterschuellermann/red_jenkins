# RedJenkins

## Installation

**Step 1:** Changing into your plugin directory (e.g. C:\Bitnami\redmine-3.0.0-0\apps\redmine\htdocs\plugins) and clone the project by:

`git clone https://github.com/Pepperrs/red_jenkins.git`

**Step 2:** Changing into your root directory of Redmine (e.g. C:\Bitnami\redmine-3.0.0-0\apps\redmine\htdocs) and run the following command:

`rake redmine:plugins:migrate RAILS_ENV=production`
or
`bundle exec rake redmine:plugins:migrate RAILS_ENV=production`

**Step 3:** Restart Redmine

_See also: http://www.redmine.org/projects/redmine/wiki/Plugins_

