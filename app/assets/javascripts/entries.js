// Handles panel collapses (entries index)
function handle_collapses() {
	$(".panel-collapse").on("show.bs.collapse", function() {
		var panel_body = $(this).children();
		$.get("/entries/"+$(this).attr("id")+".json", function(data) {
			panel_body.html(data["content"]["html"]);
		});
	});
}
