# global functions

window.delay = (ms, func) -> setTimeout func, ms

jQuery.fn.reverse = [].reverse;

window.dictionary = (word) ->
  dict = {
    'en': {
      'Today': 'Today',
    },
    'fr': {
      'Today': "Aujourd'hui",
    },
  }
  inLocale = dict[$('html').attr('lang')]
  if inLocale?
    inLocale[word] || ''
  else
    ''

# end global functions

initializeHeadroom = () ->
  $("html").headroom()

windowLoadChecker = ->
  window.windowHasLoaded = false
  $(window).load ->
    window.windowHasLoaded = true


$ ->
  initializeHeadroom()
  windowLoadChecker()
  $(document).foundation({
    reveal:
      opened: ->
        $('body').addClass('modal-open')
      close: ->
        $('body').removeClass('modal-open')
    equalizer:
      equalize_on_stack: true
    tab:
      callback: ->
        $(document).foundation('equalizer', 'reflow')
  })