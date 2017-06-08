// Global vars/funcs (for ESLint)
/* global rightSidebarUncheck, setNavbarActive */

// Handles sidebar nav links
function handleSidebarActive() {
  $('.sidebar-nav').find('.active').removeClass('active')
  $(this).parent().addClass('active')
  rightSidebarUncheck()
  setNavbarActive()
}

// Unselects all elements of sidebar
function sidebarUnselect() {
  $('.sidebar-nav').find('.active').removeClass('active')
}

// Sets sidebar listeners
function setSidebarListeners() {
  $('.sidebar-nav a').on('click', handleSidebarActive)
}
