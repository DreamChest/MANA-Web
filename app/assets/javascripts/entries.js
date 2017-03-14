// Handles panel collapses (entries index)
function handle_entries() {
	$(document).on("show.bs.collapse", ".panel-collapse", function() {
		var panel_body = $(this).children();
		if(panel_body.html()=="") {
			$.get("/entries/"+$(this).attr("id")+".json", function(data) {
				panel_body.html(data["content"]["html"]);
			});
		}
	});
}

// Handles "load more" button
function load_more() {
	var last_date = $(".entry").last().attr("date");
	var source = $(this);
	source.hide();
	$(".loading-icon").css("display", "inline");

	$.ajax({
		url: source.attr("href"),
		type: "GET",
		data: {
			date: last_date
		},
		success: function(result) {
			$("#entries").append($(result).find(".entry"));
			source.show();
			$(".loading-icon").css("display", "none");
		},
	});

	console.log("foo");
}

// Handles the "back to top" link
function go_to_top() {
	$('body,html').animate({
		scrollTop: 0
	}, 600);

	console.log("bar");

	return false;
}

// Handles the "back to top" link display
function handle_gtt() {
    if ($(this).scrollTop() > 50) {
		$("#load-more-btn").css({transformOrigin: "0px 0px"}).transition({scale: [1, 1]});
		$("#totop").transition({opacity: 1});
    } else {
		$("#load-more-btn").css({transformOrigin: "0px 0px"}).transition({scale: [1.04, 1]});
		$("#totop").transition({opacity: 0});
    }
}

//...
function entries_js() {
    handle_entries();
    $("#load-more-btn").click(load_more);
    $("#totop").click(go_to_top);
    $(window).scroll(handle_gtt);
}
