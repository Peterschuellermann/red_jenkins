class TestcasesController < ApplicationController

    include TestcasesHelper

    def index
        @project = Project.find(params[:project_id])
        @testcases = Testcase.where(:project_id => @project)

        # This variable is used to build the testcase tree
        @testcase_tree = {}
        # For each testcase t
        @testcases.each do |t|
            # add t to the tree
            add @testcase_tree, t.path.split("."), t
        end

        # This is to allow different formats for the server response
        # The format depends on the http request, which may contain an
        # "Accept: ..." attribute to ask for a preferred response type.
        respond_to do |format|
            format.html
            # The following just plainly renders the testcase_tree variable as a json object
            format.json { render json: @testcase_tree }
        end

    end

    def show
        #leer
    end

    def progress
        testcases = Testcase.joins(:testcase_issue_relations).where("testcase_issue_relations.issue_id = ?", params[:issue_id])
        res = {}
        testcases.each do |t|
            res[t.status] ||= 0
            res[t.status] += 1
        end
        render json: res
    end

    def new
        # Remember to put this in front of (every) controller method, so that
        # redmine can show the project menu links
        @project = Project.find(params[:project_id])
        @testcases_available = Testcase.where(:project_id => @project)
        @testcase = Testcase.new
    end

    def edit
        @project = Project.find(params[:project_id])
        @testcase = Testcase.find(params[:id])
    end

    def create
        @project = Project.find(params[:project_id])
        testcase_input = testcase_params
        testcase_input["time_last_run"] = DateTime.now
        testcase_input["status"] = "FAILED"
        testcase_input["test_type"] = "MANUAL"
        testcase_input["project_id"] = @project.id
        @testcase = Testcase.new(testcase_input)

        if @testcase.save
            redirect_to :action => 'index'#, :status => :created, :location => issue_url(@issue)
        else
            @testcases_available = Testcase.where(:project_id => @project)
            render 'new'
        end
    end

    def update
        @project = Project.find(params[:project_id])
        @testcase = Testcase.find(params[:id])
        testcase_input = testcase_params
        testcase_input["time_last_run"] = DateTime.now
        testcase_input["test_type"] = "MANUAL"

        if @testcase.update(testcase_input)
            redirect_to testcases_path
        else
            render 'edit'
        end
    end

    def destroy
        @project = Project.find(params[:project_id])
        @testcase = Testcase.find(params[:id])
        @testcase.destroy

        redirect_to testcases_path
    end

    private
    def testcase_params
        params.require(:testcase).permit(:name, :description, :path)
    end


end
