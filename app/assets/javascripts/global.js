// Dynamically loads a link into the page content wrapper
function dynamic_content_load() {
	$("#page-modal").modal("hide");
	$("#page-content").load($(this).attr("href")+" #page-content");

	return false;
}

// Dynamically loads a link into a modal
function dynamic_modal_load() {
	$("#page-modal-content").load($(this).attr("href")+" #page-content", function() {
		var title = $("#page-modal-content").find("#page-title");

		$("#page-modal-title").text(title.text());
		title.remove();
	});
	$("#page-modal").modal("show");

	return false;
}

// Dynamically loads a link into the page sidebars and page content (for delete http method)
function dynamic_delete_load() {
	$.ajax({
		url: $(this).attr("href"),
		type: "DELETE",
		success: function(result) {
			$("#page-content").html($(result).find("#page-content").html());
			$("#sidebar-wrapper").html($(result).find("#sidebar-wrapper").html());
			$("#sidebar-wrapper-right").html($(result).find("#sidebar-wrapper-right").html());
		}
	});
	return false;
}
