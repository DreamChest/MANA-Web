// Dynamically loads a link into the page content wrapper
function dynamic_content_load() {
	var source = $(this);

	$.ajax({
		url: source.attr("href"),
		type: "GET",
		dataType: "html",
		success: function(result) {
			$("#page-content").html(result);

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
		dataType: "html",
		success: function(result) {
			$("#page-modal-content").html(result);

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
	$("#page-content").html(result);

	$.ajax({
		url: "/sidebars",
		type: "GET",
		dataType: "html",
		success: function(res) {
			$("#sidebar-wrapper").html($(res).filter("#sidebar-wrapper").html());
			$("#sidebar-wrapper-right").html($(res).filter("#sidebar-wrapper-right").html());
		}
	});

	set_application_listeners();
}

// Dynamically loads a link into the page sidebars and page content (for delete http method)
function dynamic_delete_load() {
	$.ajax({
		url: $(this).attr("href"),
		type: "DELETE",
		dataType: "html",
		success: dynamic_full_load
	});

	return false;
}

// Dynamicaly load back link after form submission
function dynamic_form_load() {
	$.ajax({
		url: $("#back").attr("href"),
		type: "GET",
		dataType: "html",
		success: dynamic_full_load
	});

	$("#page-modal").modal("hide");
}

// Disable button and show loading icon when needed
function show_loading_icon() {
	$(this).prop("disabled", true);
	$(".loading-icon").css("display", "inline");
}

// Enable button and hide loading icon when needed
function hide_loading_icon() {
	$(".load").prop("disabled", false);
	$(".loading-icon").css("display", "none");
}

// Function to render form errors
$.fn.render_form_errors = function(model, errors) {
	var form = this;

	// Remove previous errors (if needed)
	form.find('.form-group').removeClass('has-error')
	form.find('span.help-block').remove()

	// Add errors to input fields (if needed)
	return $.each(errors, function(field, messages) {
		var input = form.find('input, select, textarea').filter(function() {
			var name = $(this).attr('name');
			if (name) return name.match(new RegExp(model + '\\[' + field + '\\(?'));
		});

		input.closest('.form-group').addClass('has-error');

		return input.parent().append('<span class="help-block">' + $.map(messages, function(m) {
			return m.charAt(0).toUpperCase() + m.slice(1);
		}).join('<br />') + '</span>');
	});
};

// Sets listeners for application-wide functions
function set_application_listeners() {
	// For dynamic content loading
	$(".dyn-content").off("click.dyn-content").on("click.dyn-content", dynamic_content_load); // Dynamic page load
	$(".dyn-modal").off("click.dyn-modal").on("click.dyn-modal", dynamic_modal_load); // Dynamic modal load
	$(".dyn-delete").off("click.dyn-delete").on("click.dyn-delete", dynamic_delete_load); // Dynamic delete query

	// For buttons that should be disabled on click and should display a loading icon
	$(".load").off("click.load").on("click.load", show_loading_icon);

	// Ajax setup for dynamic forms
	$.ajaxSetup({
		dataType: 'json'
	});

	// For dynamic forms
	$(".dyn-form")
		.on("ajax:success", dynamic_form_load)
		.on("ajax:error", function(e, data, status, xhr) {
			$(".dyn-form").render_form_errors($(".dyn-form").attr("for"), data.responseJSON);
			hide_loading_icon();
		});
}
