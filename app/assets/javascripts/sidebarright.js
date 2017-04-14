// Handles tag filtering
function handle_tag_filtering() {
	var $tags = $(".tag_cb").filter(":checked");
	var len = $tags.length;
	var val = "";

	$tags.each(function(index) {
		val += $(this).val();
		if(index != len-1) val += ",";
	});

	$("#page-modal").modal("hide");
	$("#page-content").load(encodeURI($(this).attr("url")+val)+" #page-content", function() {
		set_application_listeners();
		entries_js();
	});

	sidebar_unselect();
	set_navbar_active();
}

// Unchecks all checkboxes of sidebar
function right_sidebar_uncheck() {
	$(".tag_cb").filter(":checked").removeAttr("checked");
}

// Sets right sidebar listeners
function set_right_sidebar_listeners() {
	$(".tag_cb").on("click", handle_tag_filtering);
}
