$("#locale_dropdown .selected").click ->
  $("#locale_dropdown .menu").toggle()
  
  return false

$("#locale_dropdown").click (event) -> event.stopPropagation()

$(document).click -> $("#locale_dropdown .menu").hide()
