// Dynamically loads a link into the page content wrapper
function dynamic_content_load() {
	var source = $(this);
	var update_navbar = false;

	if(source.hasClass("neveractive")) update_navbar = true;

	$("#page-modal").modal("hide");
	$("#page-content").load(source.attr("href")+" #page-content", function() {

		if(update_navbar == true) {
			set_navbar_active();
			$("#update_all").removeClass("fa-spin");
		}
	});

	return false;
}

// Dynamically loads a link into a modal
function dynamic_modal_load() {
	var source = $(this);

	$("#page-modal-content").load(source.attr("href")+" #page-content", function() {
		var title = $("#page-modal-content").find("#page-title");

		$("#page-modal-title").text(title.text());
		title.remove();

		post_load(source);
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

// Sets all needed listeners
function set_listeners() {
    $(document).on("click", ".dyn-content", dynamic_content_load);
    $(document).on("click", ".dyn-modal", dynamic_modal_load);
    $(document).on("click", ".dyn-delete", dynamic_delete_load);
    $(document).on("ajax:complete", ".dyn-form", dynamic_form_load);
    $(document).on("click", ".load", show_loading_icon);
}

function post_load(source) {
	if(source.hasClass("selectize")) handle_selectize();
	if(source.hasClass("jscolor")) handle_jscolor();
}
