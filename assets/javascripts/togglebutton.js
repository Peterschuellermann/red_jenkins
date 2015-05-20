function toggle(project_path, testcase) {

    $.ajax({
        url: project_path + "/testcases/" + testcase + "/toggle"
    }).done(function(data) {
        $("#test_" + data.id).removeClass("passed").removeClass("failed").addClass(data.status.toLowerCase());
        $("#test_" + data.id).find("#status").html("/// " + data.status.toLowerCase() + " ///");

        timelastrun = new Date(data.time_last_run)
        day = timelastrun.getDate();
        month = timelastrun.getMonth() + 1;
        year = timelastrun.getFullYear();
        hours = timelastrun.getHours();
        minutes = timelastrun.getMinutes();
        timelastrunstring =
            (day < 10 ? "0" : "") + day + "." + 
            (month < 10 ? "0" : "") + month + "." + year + " " + hours + ":" + minutes;

        $("#test_" + data.id).find("#time_last_run").html(timelastrunstring);
        var progress = $("#issuetestprogress");
        var change = data.status.toLowerCase() == "passed" ? 1 : -1;
        progress.attr("value", parseInt(progress.attr("value")) + change);
    });

}