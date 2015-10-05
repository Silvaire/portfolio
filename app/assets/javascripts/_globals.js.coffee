window.delay = (ms, func) -> setTimeout func, ms

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