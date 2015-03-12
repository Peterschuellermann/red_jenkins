class JenkinshandlerController < ApplicationController
  require 'jenkins_api_client'


	def updatecases
		connect_to_jenkins
		get_latest_test_results
		parse_test_results
		compare_test_results
		
	
	end
	
	def index
	end
	
	def show
	end
	
	def new
	end
	
	def edit
	end
	
	def create(testcase_input)
		input = {}
		input["name"] = testcase_input["name"]
		input["path"] = testcase_input["className"]
		input["status"] = testcase_input["status"]
		input["test_type"] = "AUTOMATIC"
		input["time_last_run"] = DateTime.now
		@testcase = Testcase.new(input)
				
		if @testcase.save			
		else
		end
	end
	
	def update(testcase_input, id)
		@testcase = Testcase.find(id)
		input = {}
		input["name"] = testcase_input["name"]
		input["path"] = testcase_input["className"]
		input["status"] = testcase_input["status"]
		input["test_type"] = "AUTOMATIC"
		input["time_last_run"] = DateTime.now
		
		if @testcase.update(input)
		else
		end
	end
	
	def destroy(id)
		@testcase = Testcase.find(id)
		@testcase.destroy
	end
	
	
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

	private
		def connect_to_jenkins
			@client = JenkinsApi::Client.new(:server_ip => '52.16.157.73', :server_port => '80',:jenkins_path => '/jenkins/',
			:username => 'user', :password => 'IXutnKRARd1x')
		end
		
	private
		def get_latest_test_results
		
			current_build = @client.job.get_current_build_number('Test')
			@test_result = @client.job.get_test_results('Test',current_build)
		end
		
	private	
		def compare_test_results
			testcases = Testcase.all
			
			@test_result_parsed.each do |r|
				testcases.each do |t|
					if r["name"] == t["name"] && r["path"] == t["path"]
						self.update(r,t[:id])
						@test_result_parsed.delete(r)
						testcases.delete(t)
					end
				end
			end
			
			@test_result_parsed.each do |r|
				self.create(r)
			end
			
			testcases.each do |t|
				self.destroy(t[:id])
			end
		end


end
