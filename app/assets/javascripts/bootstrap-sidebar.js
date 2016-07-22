// Handle hamburger button for the sidebar
function handle_hamburger() {
	var trigger = $('.hamburger'),
		overlay = $('.overlay'),
			isClosed = false;

			trigger.click(function () {
				hamburger_cross();      
			});

			function hamburger_cross() {

				if (isClosed == true) {          
					overlay.hide();
					trigger.removeClass('is-open');
					trigger.addClass('is-closed');
					isClosed = false;
				} else {   
					overlay.show();
					trigger.removeClass('is-closed');
					trigger.addClass('is-open');
					isClosed = true;
				}
			}

			$('[data-toggle="offcanvas"]').click(function () {
				$('#wrapper').toggleClass('toggled');
			});  
}

// Makes the sidebar permanent
function pin() {
	$(".overlay").hide();
	$(".hamburger").hide();
	$("#pin").addClass("pinned");
	$("#page-content-wrapper").css("position", "relative");
	$("#page-content-wrapper").css("padding-top", "28px");
}

// Makes the sidebar dynamic
function unpin() {
	$(".overlay").show();
	$(".hamburger").show();
	$("#pin").removeClass("pinned");
	$("#page-content-wrapper").css("position", "absolute");
	$("#page-content-wrapper").css("padding-top", "70px");
}
