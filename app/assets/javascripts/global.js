// Global vars/funcs (for ESlint)
/* global setNavbarActive */

// Dynamically loads a link into the page content wrapper
function dynamicContentLoad() {
  var source = $(this)

  $.ajax({
    url: source.attr('href'),
    type: 'GET',
    dataType: 'html',
    success: function(result) {
      $('#page-content').html(result)

      if (source.hasClass('neveractive')) {
        setNavbarActive()
        $('#update_all').removeClass('fa-spin')
      }

      $('#page-modal').modal('hide')

      setApplicationListeners()
    }
  })

  return false
}

// Dynamically loads a link into a modal
function dynamicModalLoad() {
  var source = $(this)

  $.ajax({
    url: source.attr('href'),
    type: 'GET',
    dataType: 'html',
    success: function(result) {
      $('#page-modal-content').html(result)

      var title = $('#page-modal-content').find('#page-title')
      $('#page-modal-title').text(title.text())
      title.remove()

      $('#page-modal').modal('show')

      setApplicationListeners()
    }
  })

  return false
}

// Loads sidebars content
function dynamicSidebarLoad() {
  $.ajax({
    url: '/sidebars',
    type: 'GET',
    dataType: 'html',
    success: function(res) {
      $('#sidebar-wrapper').html($(res).filter('#sidebar-wrapper').html())
      $('#sidebar-wrapper-right').html($(res).filter('#sidebar-wrapper-right').html())
    }
  })
}

// Loads page-content and sidebars contents
function dynamicFullLoad() {
  var source = $(this)

  $.ajax({
    url: source.attr('href'),
    type: 'GET',
    dataType: 'html',
    success: function(result) {
      $('#page-content').html(result)

      $('#page-modal').modal('hide')

      dynamicSidebarLoad()

      setApplicationListeners()
    }
  })

  return false
}

// Loads page-content and sidebars contents from ajax result
function dynamicFullLoadCallback(result) {
  $('#page-content').html(result)

  dynamicSidebarLoad()

  setApplicationListeners()
}

// Dynamically loads a link into the page sidebars and page content (for delete http method)
function dynamicDeleteLoad() {
  $.ajax({
    url: $(this).attr('href'),
    type: 'DELETE',
    dataType: 'html',
    success: dynamicFullLoadCallback
  })

  return false
}

// Dynamicaly load back link after form submission
function dynamicFormLoad() {
  $.ajax({
    url: $('#back').attr('href'),
    type: 'GET',
    dataType: 'html',
    success: dynamicFullLoadCallback
  })

  $('#page-modal').modal('hide')
}

// Disable button and show loading icon when needed
function showLoadingIcon() {
  $(this).prop('disabled', true)
  $('.loading-icon').css('display', 'inline')
}

// Enable button and hide loading icon when needed
function hideLoadingIcon() {
  $('.load').prop('disabled', false)
  $('.loading-icon').css('display', 'none')
}

// Function to render form errors
$.fn.render_form_errors = function(model, errors) {
  var form = this

  // Remove previous errors (if needed)
  form.find('.form-group').removeClass('has-error')
  form.find('span.help-block').remove()

  // Add errors to input fields (if needed)
  return $.each(errors, function(field, messages) {
    var input = form.find('input, select, textarea').filter(function() {
      var name = $(this).attr('name')
      if (name) return name.match(new RegExp(model + '\\[' + field + '\\(?'))
    })

    input.closest('.form-group').addClass('has-error')

    return input.parent().append('<span class="help-block">' + $.map(messages, function(m) {
      return m.charAt(0).toUpperCase() + m.slice(1)
    }).join('<br />') + '</span>')
  })
}

// Sets listeners for application-wide functions
function setApplicationListeners() {
  // For dynamic content loading
  $('.dyn-content').off('click.dyn-content').on('click.dyn-content', dynamicContentLoad) // Dynamic page load
  $('.dyn-content-full').off('click.dyn-content-full').on('click.dyn-content-full', dynamicFullLoad) // Dynamic full (page content + sidebars) page load
  $('.dyn-modal').off('click.dyn-modal').on('click.dyn-modal', dynamicModalLoad) // Dynamic modal load
  $('.dyn-delete').off('click.dyn-delete').on('click.dyn-delete', dynamicDeleteLoad) // Dynamic delete query

  // For buttons that should be disabled on click and should display a loading icon
  $('.load').off('click.load').on('click.load', showLoadingIcon)

  // Ajax setup for dynamic forms
  $.ajaxSetup({
    dataType: 'json'
  })

  // For dynamic forms
  $('.dyn-form')
  .on('ajax:success', dynamicFormLoad)
  .on('ajax:error', function(e, data) {
    $('.dyn-form').render_form_errors($('.dyn-form').attr('for'), data.responseJSON)
    hideLoadingIcon()
  })
}
