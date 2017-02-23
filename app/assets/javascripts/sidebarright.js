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
	$("#page-content").load(encodeURI($(this).attr("url")+val)+" #page-content");
}
