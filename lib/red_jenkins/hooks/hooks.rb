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
    
   end

end