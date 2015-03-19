class TestcaseIssueRelation < ActiveRecord::Base
    belongs_to :testcase
    belongs_to :issue

    validates :issue, uniqueness: {scope: :testcase}

end
