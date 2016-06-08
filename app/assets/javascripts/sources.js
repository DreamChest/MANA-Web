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
