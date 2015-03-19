function toggle(project, testcase) {

    $.ajax({
        url: "/redmine/projects/" + project + "/testcases/" + testcase + "/toggle"
    }).done(function(data) {
    	$("#test_" + data.id).removeClass("passed").removeClass("failed").addClass(data.status);
    });

}
