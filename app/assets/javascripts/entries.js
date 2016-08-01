// Handles panel collapses (entries index)
function handle_collapses() {
	$(document).on("show.bs.collapse", ".panel-collapse", function() {
		var panel_body = $(this).children();
		if(panel_body.html()=="") {
			$.get("/entries/"+$(this).attr("id")+".json", function(data) {
				panel_body.html(data["content"]["html"]);
			});
		}
	});
}
