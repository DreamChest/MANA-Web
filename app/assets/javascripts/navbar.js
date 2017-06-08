// Global vars/funcs (for ESLint)
/* global sidebarUnselect, rightSidebarUncheck */

// Sets active navbar nav link according to current url
function setNavbarActive() {
  var loc = location.pathname

  if (loc === '/') loc = '/entries'

  $('.nav').find('.active').removeClass('active')
  $('.nav a[href^="' + loc + '"]').closest('li').addClass('active')
}

// Handles navbar nav links
function handleNavbarActive() {
  $('.nav').find('.active').removeClass('active')
  $(this).parent().addClass('active')

  sidebarUnselect()
  rightSidebarUncheck()
}

// Toggles (left) sidebar
function toggleSidebar() {
  $('#wrapper').toggleClass('toggled')
  return false
}

// Toggles right sidebar
function toggleSidebarRight() {
  $('#wrapper').toggleClass('toggled-right')
  return false
}

// Handles "update all" button
function handleUpdateAll() {
  $(this).toggleClass('fa-spin')
  $(this).blur()
}

// Sets listeners for the navbar
function setNavbarListeners() {
  $('.nav a').not('.neveractive').click(handleNavbarActive)
  $('#sidebar-toggle').click(toggleSidebar)
  $('#sidebar-toggle-right').click(toggleSidebarRight)
  $('#update_all').on('click', handleUpdateAll)
}
