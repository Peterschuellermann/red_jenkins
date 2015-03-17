module TestcaseRelationHelper

    class Hooks < Redmine::Hook::ViewListener
        def controller_issues_new_after_save(context={ })
        	# If both parameters are set (then we assume a correct behavior and continue)
            if context[:params] && context[:issue]
            	TestcaseIssueRelation.

            end
        end
    end

end
