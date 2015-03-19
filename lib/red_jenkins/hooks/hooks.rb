module RedJenkins

    class Hooks < Redmine::Hook::ViewListener

        #adds a hook for issue#new
        render_on :view_issues_form_details_bottom, :partial => 'issues/testcases_new'

        # adds a hook for issue#show
        render_on :view_issues_show_description_bottom, :partial => 'issues/testcases_show'

        # adds a hook for issue#edit
        render_on :view_issues_edit_notes_bottom, :partial => 'issues/testcases_edit'

        # adds a hook for issue#index
        render_on :view_issues_index_bottom, :partial => 'issues/testcases_index'

        # This is the controller hook for saving issues with testcases
        def controller_issues_new_after_save(context={ })
            # Get the newly created issue
            issue = context[:issue]

            # TODO: Make the parameters safe and secure
            context[:params][:test].each do |id, value|

                # If the value is set to true
                if value.downcase == "true"

                    # Get the testcase with the given id
                    testcase = Testcase.find(id)

                    # Create an association connecting the current testcase
                    # with the given issue
                    testcase.issues << issue

                    # TODO: Is this necessary?
                    testcase.save
                end
            end
        end

    end

end
