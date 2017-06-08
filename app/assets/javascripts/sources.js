// Handles selectize and it's default value(s)
function handleSelectize() {
  var tagsField = $('#source_tagslist_attr')

  var options = {
    persist: false,
    createOnBlur: true,
    create: true
  }

  var $select = tagsField.selectize(options)

  $select[0].selectize.setValue(tagsField.attr('default_values').split(','))
}

function handleUpdateBtn() {
  $('.update_btn').off('click').on('click', function(e) { e.preventDefault() })
  $('.update_btn').attr('disabled', true)
  $(this).children().addClass('fa-spin')
}

function sourcesJs() {
  $('.update_btn').off('click.update_btn').on('click.update_btn', handleUpdateBtn)
}
