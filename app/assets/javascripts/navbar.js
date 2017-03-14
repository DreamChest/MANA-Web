// Sets active navbar nav link according to current url
function set_navbar_active() {
	var loc = location.pathname;

	if(loc=="/") loc = "/entries";

	$('.nav').find(".active").removeClass('active');
	$('.nav a[href^="'+loc+'"]').closest('li').addClass('active');
}

// Handles navbar nav links
function handle_navbar_active() {
	$(".nav").find(".active").removeClass("active");
	$(this).parent().addClass("active");

	$(".sidebar-nav").find(".active").removeClass("active");
}

// Toggles (left) sidebar
function toggle_sidebar() {
	$("#wrapper").toggleClass("toggled");
	return false;
}

// Toggles right sidebar
function toggle_sidebar_right() {
	$("#wrapper").toggleClass("toggled-right");
	return false;
}

// Handles "update all" button
function handle_update_all() {
	$(this).toggleClass("fa-spin");
	$(this).blur();
}

// Sets listeners for the navbar
function set_navbar_listeners() {
	$(".nav a").not(".neveractive").click(handle_navbar_active);
	$("#sidebar-toggle").click(toggle_sidebar);
	$("#sidebar-toggle-right").click(toggle_sidebar_right);
	$("#update_all").on("click", handle_update_all);
}
