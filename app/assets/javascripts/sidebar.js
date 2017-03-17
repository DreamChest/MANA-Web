// Handles sidebar nav links
function handle_sidebar_active() {
	$(".sidebar-nav").find(".active").removeClass("active");
	$(this).parent().addClass("active");
	right_sidebar_uncheck();
}

// Sets sidebar listeners
function set_sidebar_listeners() {
	$(".sidebar-nav a").on("click", handle_sidebar_active);
}
