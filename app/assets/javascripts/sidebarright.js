// Global vars/funcs (ESLint)
/* global setApplicationListeners, entriesJs, sidebarUnselect, setNavbarActive */

// Handles tag filtering
function handleTagFiltering() {
  var $tags = $('.tag_cb').filter(':checked')
  var len = $tags.length
  var val = ''

  $tags.each(function(index) {
    val += $(this).val()
    if (index !== len - 1) val += ','
  })

  $('#page-modal').modal('hide')
  $('#page-content').load(encodeURI($(this).attr('url') + val), function() {
    setApplicationListeners()
    entriesJs()
  })

  sidebarUnselect()
  setNavbarActive()
}

// Unchecks all checkboxes of sidebar
function rightSidebarUncheck() {
  $('.tag_cb').filter(':checked').removeAttr('checked')
}

// Sets right sidebar listeners
function setRightSidebarListeners() {
  $('.tag_cb').on('click', handleTagFiltering)
}
