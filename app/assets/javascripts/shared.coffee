jQuery ->
  $(document).ready ->
    $("#new_child_form").hide()
jQuery ->
  $("#new_child_form_button").click ->
    $toggle = $(this)
    $("#new_child_form").toggle()
    if $("#new_child_form").is(":visible")
      $toggle.text("Hide New Child Form")
    else
      $toggle.text("Show New Child Form")