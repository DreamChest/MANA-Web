// Handles sidebar nav links
function handle_sidebar_nav() {
	$(".sidebar-nav").find(".active").removeClass("active");
	$(this).parent().addClass("active");
}
