// Dynamically loads a link into the page content wrapper
function dynamic_content_load() {
	var source = $(this);

	$.ajax({
		url: source.attr("href"),
		type: "GET",
		success: function(result) {
			$("#page-content").html($(result).find("#page-content").html());

			if(source.hasClass("neveractive")) {
				set_navbar_active();
				$("#update_all").removeClass("fa-spin");
			}

			$("#page-modal").modal("hide");

			set_application_listeners();
		}
	});

	return false;
}

// Dynamically loads a link into a modal
function dynamic_modal_load() {
	var source = $(this);

	$.ajax({
		url: source.attr("href"),
		type: "GET",
		success: function(result) {
			$("#page-modal-content").html($(result).find("#page-content").html());

			var title = $("#page-modal-content").find("#page-title");
			$("#page-modal-title").text(title.text());
			title.remove();

			$("#page-modal").modal("show");

			set_application_listeners();
		}
	});

	return false;
}

// Loads page-content and sidebars contents from ajax result
function dynamic_full_load(result) {
	$("#page-content").html($(result).find("#page-content").html());
	$("#sidebar-wrapper").html($(result).find("#sidebar-wrapper").html());
	$("#sidebar-wrapper-right").html($(result).find("#sidebar-wrapper-right").html());

	set_application_listeners();
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

// Sets listeners for application-wide functions
function set_application_listeners() {
    $(".dyn-content").off("click.dyn-content").on("click.dyn-content", dynamic_content_load);
	$(".dyn-modal").off("click.dyn-modal").on("click.dyn-modal", dynamic_modal_load);
    $(".dyn-delete").off("click.dyn-delete").on("click.dyn-delete", dynamic_delete_load);
	$(".load").off("click.load").on("click.load", show_loading_icon);

    $(".dyn-form").off("ajax:complete").on("ajax:complete", dynamic_form_load);

	$(".entries").off("click.entries").on("click.entries", handle_entries);
	$(".selectize").off("click.selectize").on("click.selectize", handle_selectize);
}
