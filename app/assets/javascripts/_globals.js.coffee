initializeHeadroom = () ->
  $("html").headroom()

$ ->
  initializeHeadroom();
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