// Adds all needed listeners (and stuff)
function init() {
	$(".tag_cb").on("change", handle_tags);
}

// Handle tags filtering (Entries index)
function handle_tags() {

	var filter = false;
	$("tr").hide();

	$(".tag_cb").each(function() {
		if(this.checked==true) {
			filter = true;
			$("tr[class*='"+this.name+"']").show();
		}
	});

	if(filter==false) $("tr").show();
}
