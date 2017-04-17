// Handles selectize and it's default value(s)
function handle_selectize() {
	var tags_field = $("#source_tagslist_attr");

	var options = {
		persist: false,
		createOnBlur: true,
		create: true
	};

	var $select = tags_field.selectize(options);

	$select[0].selectize.setValue(tags_field.attr("default_values").split(','));
}

function handle_update_btn() {
	$(".update_btn").off("click").on("click", function(e) { e.preventDefault() });
	$(".update_btn").attr("disabled", true);
	$(this).children().addClass("fa-spin");
}

function sources_js() {
	$(".update_btn").off("click.update_btn").on("click.update_btn", handle_update_btn);
}
