// Global vars/funcs (for ESLint)
/* global sidebarUnselect, rightSidebarUncheck */

// Handles panel collapses (entries index)
function handleEntries() {
  $(document).off('show.bs.collapse').on('show.bs.collapse', '.panel-collapse', function() {
    var panelBody = $(this).children()
    if (panelBody.html() === '') {
      $.get('/entries/' + $(this).attr('id') + '.json', function(data) {
        panelBody.html(data['content']['html'])
      })
    }
  })
}

// Handles "load more" button
function loadMore() {
  var lastDate = $('.entry').last().attr('date')
  var source = $(this)

  source.hide()
  $('#totop').hide()
  $('.loading-icon').css('display', 'inline')

  $.ajax({
    url: source.attr('href'),
    type: 'GET',
    dataType: 'html',
    data: {
      date: lastDate
    },
    success: function(result) {
      var entries = $(result).find('.entry')

      if (entries.length > 0) {
        $('#entries').append(entries)
        source.show()
        $('#totop').show()
        $('.loading-icon').css('display', 'none')
      } else {
        source.show()
        $('#totop').show()
        $('.loading-icon').css('display', 'none')
        source.attr('disabled', '')
        source.off('click').on('click', function() { return false })
      }
    }
  })

  return false
}

// Handles the "back to top" link
function goToTop() {
  $('body,html').animate({
    scrollTop: 0
  }, 600)

  return false
}

// Handles "clear" button for entries filtering
function handleClearBtn() {
  sidebarUnselect()
  rightSidebarUncheck()
}

// ...
function entriesJs() {
  handleEntries()
  $('#load-more-btn').off('click.load-more-btn').on('click.load-more-btn', loadMore)
  $('#totop').off('click.totop').on('click.totop', goToTop)
  $('#clear-filters-btn').off('click.clear-filters-btn').on('click.clear-filters-btn', handleClearBtn)
}
