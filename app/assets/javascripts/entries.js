// Adds all needed listeners (and stuff)
function init() {
	$(".tag_cb").on("change", handle_tags);
}

// Handles tags filtering (entries index)
function handle_tags() {
	var tags = $(".tag_cb").filter(":checked");

	if(tags.size()>0) {
		$(".panel").hide();
		tags.each(function() { $(".panel").filter("."+this.name).show(); });
	}
	else {
		$(".panel").show();
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
