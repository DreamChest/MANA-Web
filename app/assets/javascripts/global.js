// Dynamically loads a link into the page content wrapper
function dynamic_content_load() {
	$("#page-modal").modal("hide");
	$("#page-content").load($(this).attr("href")+" #page-content", function() {
		$("#update_all").removeClass("fa-spin");
	});
	handle_all();

	return false;
}

// Dynamically loads a link into a modal
function dynamic_modal_load() {
	$("#page-modal-content").load($(this).attr("href")+" #page-content", function() {
		var title = $("#page-modal-content").find("#page-title");

		$("#page-modal-title").text(title.text());
		title.remove();
		handle_all();
	});
	$("#page-modal").modal("show");

	return false;
}

// Loads page-content and sidebars contents from ajax result
function dynamic_full_load(result) {
	$("#page-content").html($(result).find("#page-content").html());
	$("#sidebar-wrapper").html($(result).find("#sidebar-wrapper").html());
	$("#sidebar-wrapper-right").html($(result).find("#sidebar-wrapper-right").html());
}

// Dynamically loads a link into the page sidebars and page content (for delete http method)
function dynamic_delete_load() {
	$.ajax({
		url: $(this).attr("href"),
		type: "DELETE",
		success: dynamic_full_load
	});
	return false;
}

// Dynamicaly load back link after form submission
function dynamic_form_load() {
	$.ajax({
		url: $("#back").attr("href"),
		type: "GET",
		success: dynamic_full_load
	});
	$("#page-modal").modal("hide");
}

// Disable button and show loading icon when needed
function show_loading_icon() {
	$(this).attr("disabled", "");
	$(".loading-icon").css("visibility", "visible");
}

// Yup, that's dirty, but temporary (maybe)
function ftry(f) {
	try {
		f();
	} catch(err) {};
}

// Calls all (all needed at least) handlers
function handle_all() {
	ftry(handle_collapses);
	ftry(handle_selectize);
	ftry(handle_jscolor);
}
