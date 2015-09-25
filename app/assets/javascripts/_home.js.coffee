animateOnLoad = ->
  $homepageContent = $('.homepage__content')
  if $homepageContent.length
    $homepageContent.addClass('loaded')
    


$(window).load ->
  animateOnLoad()