// Sets active navbar nav link according to current url
function set_active(l) {
	if(l == null) var loc = location.pathname;
	else var loc = l;

	if(loc=="/") loc = "/entries";

	$('.nav').find(".active").removeClass('active');
	$('.nav a[href^="'+loc+'"]').closest('li').addClass('active');
}

// Handles navbar nav links
function handle_navbar_nav() {
	$(".nav").find(".active").removeClass("active");
	$(".sidebar-nav").find(".active").removeClass("active");
	$(this).parent().addClass("active");
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
