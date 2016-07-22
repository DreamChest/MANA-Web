// Handles tag filtering (entries index)
function tag_filtering() {
	var args = location.search.split("tags=");

	if(args.length>1) {
		var tags = args[1].split(",");

		if(tags.length>0) {
			$(".panel").hide();
			for(var i = 0; i<tags.length; i++) {
				$(".panel").filter("."+tags[i]).show();
			}
		}
		else {
			$(".panel").show();
		}
	}
}


// Handles panel collapses (entries index)
function handle_collapses() {
	$(".panel-collapse").on("show.bs.collapse", function() {
		var panel_body = $(this).children();
		$.get("/entries/"+$(this).attr("id")+".json", function(data) {
			panel_body.html(data["content"]["html"]);
		});
	});
}
