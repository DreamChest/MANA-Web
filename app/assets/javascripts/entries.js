// Adds all needed listeners (and stuff)
function init() {
	$(".tag_cb").on("change", handle_tags);
}

// Handle tags filtering (Entries index)
function handle_tags() {

	var tags = $(".tag_cb").filter(":checked");

	if(tags.size()>0) {
		$("tr").hide();
		tags.each(function() { $("tr").filter("."+this.name).show(); });
	}
	else {
		$("tr").show();
	}
}
