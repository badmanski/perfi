$(document).on 'ready page:load', ->
  $('.alert').each ->
    $(@).delay(3000).fadeOut()
