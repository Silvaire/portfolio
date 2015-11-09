moveBackgroundOnMouseMove = ->
  $el = $('.section--homepage')
  $target = $el.find('.homepage__background-picture')
  h = $el.outerHeight()
  w = $el.outerWidth()
  sh = 50 / h
  sw = 50 / w
  i = 0
  $el.mousemove( (e) ->
    pageX = e.pageX || e.clientX
    pageY = e.pageY || e.clientY
    pageX = (pageX - $el.offset().left) - (w / 2)
    pageY = (pageY - $el.offset().top) - (h / 2)
    newX = ((sw * pageX)) * - 1
    newY = ((sh * pageY)) * - 1
    transformParams = "translate3d(" + newX + "px," + newY + "px, 0px)"
    # # Use matrix to move the background from its origin
    # # Also, disable transition to prevent lag
    $target.css({
      "-webkit-transform": transformParams,
      "-moz-transform": transformParams,
      "-o-transform": transformParams,
      "transform": transformParams,
      "-webkit-transition": "none",
      "-moz-transition": "none",
      "-o-transition": "none",
      "transition": "none"
    })
  )

animateOnLoad = ->
  $homepageContainer = $('.section--homepage')
  if $homepageContainer.length
    $homepageContainer.addClass('loaded')
    # moveBackgroundOnMouseMove()


$(window).load ->
  animateOnLoad()