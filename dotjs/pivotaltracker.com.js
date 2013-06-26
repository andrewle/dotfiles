$(document).on('keydown', 'form.story *, form.story textarea', function(e) {
  if(e.keyCode == 13 && (e.metaKey || e.ctrlKey)) {
    $(this).parents('form').find('button.save').click()
  }
})
