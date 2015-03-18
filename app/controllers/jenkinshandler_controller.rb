class JenkinshandlerController < ApplicationController
  require 'jenkins_api_client'
	
	
	# Initializes the class using the values stored in the plugins settings.
	# Checks if the input is an empty string and sets the value to nil
	def initialize
		@jenkins_settings =  {}
		

	      if Setting.plugin_red_jenkins['red_jenkins_server_url'].to_s == ""
	      @jenkins_settings[:server_url] = nil
	      else
		  @jenkins_settings[:server_url] = Setting.plugin_red_jenkins['red_jenkins_server_url'].to_s
		  end
		  
		  if Setting.plugin_red_jenkins['red_jenkins_server_ip'].to_s == ""
		  @jenkins_settings[:server_ip] = nil
		  else
		  @jenkins_settings[:server_ip] = Setting.plugin_red_jenkins['red_jenkins_server_ip'].to_s
		  end
		  
		  if Setting.plugin_red_jenkins['red_jenkins_server_port'].to_s ==""
		  @jenkins_settings[:server_port] = nil
		  else
		  @jenkins_settings[:server_port] = Setting.plugin_red_jenkins['red_jenkins_server_port'].to_s
		  end
		  
		  if Setting.plugin_red_jenkins['red_jenkins_proxy_ip'].to_s == ""
		  @jenkins_settings[:proxy_ip] = nil
		  else
		  @jenkins_settings[:proxy_ip] = Setting.plugin_red_jenkins['red_jenkins_proxy_ip'].to_s
		  end
		  
		  if Setting.plugin_red_jenkins['red_jenkins_proxy_port'].to_s == ""
		  @jenkins_settings[:proxy_port] = nil
		  else
		  @jenkins_settings[:proxy_port] = Setting.plugin_red_jenkins['red_jenkins_proxy_port'].to_s
		  end
		  
		  if Setting.plugin_red_jenkins['red_jenkins_jenkins_path'].to_s == ""
		  @jenkins_settings[:jenkins_path] = "/"
		  else
		  @jenkins_settings[:jenkins_path] = Setting.plugin_red_jenkins['red_jenkins_jenkins_path'].to_s
		  end
		  
		  if Setting.plugin_red_jenkins['red_jenkins_username'].to_s == ""
		  @jenkins_settings[:username] = nil
		  else
		  @jenkins_settings[:username] = Setting.plugin_red_jenkins['red_jenkins_username'].to_s
		  end
		  
		  if Setting.plugin_red_jenkins['red_jenkins_password'].to_s == ""
		  @jenkins_settings[:password] = nil
		  else
		  @jenkins_settings[:password] = Setting.plugin_red_jenkins['red_jenkins_password'].to_s
		  end
		  
		  if Setting.plugin_red_jenkins['red_jenkins_password_base64'].to_s == ""
		  @jenkins_settings[:password_base64] = nil
		  else
		  @jenkins_settings[:password_base64] = Setting.plugin_red_jenkins['red_jenkins_password_base64'].to_s
		  end
		  
		  if Setting.plugin_red_jenkins['red_jenkins_log_location'].to_s == ""
		  @jenkins_settings[:log_location] = nil
		  else
		  @jenkins_settings[:log_location] = Setting.plugin_red_jenkins['red_jenkins_log_location'].to_s
		  end
		  
		  if Setting.plugin_red_jenkins['red_jenkins_log_level'].to_s == ""
		  @jenkins_settings[:log_level] = 1
		  else
		  @jenkins_settings[:log_level] = Setting.plugin_red_jenkins['red_jenkins_log_level'].to_i
		  end
		  
		  if Setting.plugin_red_jenkins['red_jenkins_timeout'].to_s == ""
		  @jenkins_settings[:timeout] = 120
		  else 
		  @jenkins_settings[:timeout] = Setting.plugin_red_jenkins['red_jenkins_timeout'].to_i
		  end
		  
		  if Setting.plugin_red_jenkins['red_jenkins_http_open_timeout'].to_s == ""
		  @jenkins_settings[:http_open_timeout] == 120
		  else
		  @jenkins_settings[:http_open_timeout] = Setting.plugin_red_jenkins['red_jenkins_http_open_timeout'].to_i
		  end
		  
		  if Setting.plugin_red_jenkins['red_jenkins_http_read_timeout'].to_s == ""
		  @jenkins_settings[:http_read_timeout] = 120
		  else
		  @jenkins_settings[:http_read_timeout] = Setting.plugin_red_jenkins['red_jenkins_http_read_timeout'].to_i
		  end
		  
		  @jenkins_settings[:ssl] = Setting.plugin_red_jenkins['red_jenkins_ssl']
		  
		  @jenkins_settings[:follow_redirects] = Setting.plugin_red_jenkins['red_jenkins_follow_redirects']
		
		  
		  if Setting.plugin_red_jenkins['red_jenkins_identity_files'].to_s == ""
		  @jenkins_settings[:identity_file] = nil
		  else
		  @jenkins_settings[:identity_file] = Setting.plugin_red_jenkins['red_jenkins_identity_files'].to_s
		  end
		  
		  if Setting.plugin_red_jenkins['red_jenkins_cookies'].to_s == ""
		  @jenkins_settings[:cookies] = nil
		  else
		  @jenkins_settings[:cookies] = Setting.plugin_red_jenkins['red_jenkins_cookies'].to_s
		  end
		  
		@jenkins_job = "Test"
		

		
	end

	# Method that is called to start the update progress. Only function
	# that should be called from the outside.
	def updatecases
		connect_to_jenkins
		get_latest_test_results
		
		if @test_result.any?
			parse_test_results
			compare_test_results(params.permit(:project_id))
		end
		
		redirect_to home_path
	end
	
	def index
	end
	
	def show
	end
	
	def new
	end
	
	def edit
	end
	
	# Method is used to create a new testcase
	def create(testcase_input)
		input = {}
		input["name"] = testcase_input["name"]
		input["path"] = testcase_input["className"]
		input["status"] = testcase_input["status"]
		input["test_type"] = "AUTOMATIC"
		input["time_last_run"] = DateTime.now
		input["project_id"] = testcase_input["project_id"]
		@testcase = Testcase.new(input)
				
		if @testcase.save			
		else
		end
	end
	
	# Method is used to update an existing testcase
	def update(testcase_input, id)
		@testcase = Testcase.find(id)
		input = {}
		input["name"] = testcase_input["name"]
		input["path"] = testcase_input["className"]
		input["status"] = testcase_input["status"]
		input["test_type"] = "AUTOMATIC"
		input["time_last_run"] = DateTime.now
		input["project_id"] = testcase_input["project_id"]
		
		if @testcase.update(input)
		else
		end
	end
	
	# Method is used to delete an existing testcase
	def destroy(id)
		@testcase = Testcase.find(id)
		@testcase.destroy
	end
	
	# Method parses the returned results from jenkins into an array 
	# with all the results only from the testmethods.
	private
		def parse_test_results
			tmp_parse = []
			
			@test_result["childReports"].each do |cr|
				cr["result"]["suites"].each do |suite|
					suite["cases"].each do |method|
						tmp_parse.push(method)
					end
				end
			
			end
			
			@test_result_parsed = []
			@test_result_parsed.replace(tmp_parse)
		end

	# Method is called to connect to jenkins
	private
		def connect_to_jenkins
			@client = JenkinsApi::Client.new(@jenkins_settings)
		end
		
	# Method is called to return the latest results of the test specified 
	# by the instance variable @jenkins_job
	#
	# Returns hash containing various information about the test. An example
	# of such a return can be found in the wiki of the project 
	#
	# https://github.com/c-pid/Jenkins_Testscript/blob/master/output.json
	#
	private
		def get_latest_test_results
			current_build = @client.job.get_current_build_number(@jenkins_job)
			@test_result = @client.job.get_test_results(@jenkins_job,current_build)
		end
	
	
	# Method compares the latest test results with the database. If
	# an entry in the database matches the test result (means 'name' and
	# 'path' are identical) it will update the entry in the database 
	# with the new values from the test result. If they dont match 
	# new test from test results are added and old entries in the database
	# are removed.
	private	
		def compare_test_results(params)
			# filter for automatic tests
			testcases = Testcase.where(:test_type => "AUTOMATIC", :project_id => params["project_id"])
			
			# 2 empty array that are used to temporarly save the updated
			# entries so that we can compare them with the remaining tests
			# from our database and results
			updated_testcases_db = []
			updated_testcases_jenkins = []
			@test_result_parsed.each do |r|
				testcases.each do |t|
				if t != nil && r != nil
					if t["name"] == r["name"] && t["path"]==r["className"] 				
						r["project_id"] = params["project_id"]
						self.update(r,t[:id])
						
						# add current entry to our temp arrays
						updated_testcases_db.push(t)
						updated_testcases_jenkins.push(r)
					end
				end
				end
			end	
			
			# remove the entries from our temporarly arrays in our original arrays
			testcases = testcases - updated_testcases_db
			@test_result_parsed = @test_result_parsed - updated_testcases_jenkins
						
			#creates the entries in the database that have not been previously 
			# in the database but are in our test results that we get from jenkins
			@test_result_parsed.each do |r|
				r["project_id"] = params["project_id"]
				self.create(r)
			end
			
			# removes the entries in the database that have been previously 
			# in it but cant be found in the results from jenkins. We assume
			# that an automatic test that cant be found in our results from jenkins
			# has been deleted by the user
			testcases.each do |t|
				self.destroy(t[:id])
			end
		end


end

		#@jenkins_settings =  {
		  #:server_url => Setting.plugin_redmine_red_jenkins['red_jenkins_server_url'],
		  #:server_ip => "52.16.157.73",
		  #:server_port => "80",
		  #:proxy_ip => nil,
		  #:proxy_port => nil,
		  #:jenkins_path => " /jenkins/",
		  #:username=> "user",
		  #:password => "IXutnKRARd1x",
		  #:password_base64 => nil,
		  #:log_location => nil,
		  #:log_level => nil,
		  #:timeout => nil,
		  #:http_open_timeout => nil,
		  #:http_read_timeout => nil,
		  #:ssl => nil,
		  #:follow_redirects => nil,
		  #:identity_file => nil,
		  #:cookies => nil
