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
	$("#totop").hide();
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
			$("#totop").show();
			$(".loading-icon").css("display", "none");
		},
	});
}

// Handles the "back to top" link
function go_to_top() {
	$('body,html').animate({
		scrollTop: 0
	}, 600);

	return false;
}

//...
function entries_js() {
    handle_entries();
    $("#load-more-btn").click(load_more);
    $("#totop").click(go_to_top);
}
