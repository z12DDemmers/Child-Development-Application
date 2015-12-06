# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
jQuery ->
  $(".no_class").change ->
    child_index = $('input[name="child"]:checked').val()
    children_links = $("#radio_container").data("urls")
    $("#gross_motor_link").attr("href", children_links[child_index])
    $("#language_link").attr("href", children_links[child_index])
    $("#social_link").attr("href", children_links[child_index])
    $("#fine_motor_link").attr("href", children_links[child_index])
    $("#cognitive_link").attr("href", children_links[child_index])
    $("#self_help_link").attr("href", children_links[child_index])