// Handles sidebar nav links
function handle_sidebar_active() {
	$(".sidebar-nav").find(".active").removeClass("active");
	$(this).parent().addClass("active");
	right_sidebar_uncheck();
}

// Unselects all elements of sidebar
function sidebar_unselect() {
	$(".sidebar-nav").find(".active").removeClass("active");
}

// Sets sidebar listeners
function set_sidebar_listeners() {
	$(".sidebar-nav a").on("click", handle_sidebar_active);
}
