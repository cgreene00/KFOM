# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$ ->
  $('input[type=radio][name="profile[seller]"]').change ->
    $('div#more_info').toggleClass('hidden');
    $('.footer').css('bottom', 'auto');
  return
