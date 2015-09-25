initializeKwicks = ($projects) ->
  $projects.addClass('loaded');
  $('.kwicks').kwicks({
    maxSize : '40%',
    behavior: 'menu',
    spacing: 0,
    duration: 400,
    easing: "easeOutCubic"
  })

removeKwicks = ($projects) ->
  $('.kwicks').kwicks('destroy')
  $projects.each ->
    $this.css({width:'', left:''});

enableMajorProjectsLanding = () ->
  $featuredProjects = $('.project--featured')
  if ($featuredProjects.length)
    if $(window).width() > 1024
      $featuredProjects.each (index, element) ->
        $this = $(this)
        numberFeatured = $featuredProjects.length
        $this.css({left:index * (100/numberFeatured) + '%', zIndex:numberFeatured-index + 5})
        loadFeatured = ($project) ->
          $this.css('width', 100/numberFeatured + '%')
        timeoutCallback = -> loadFeatured($this)
        setTimeout(timeoutCallback, 250 * (index + 1) )
        
        if index == numberFeatured - 1
          kwicksCallback = ->
            initializeKwicks($featuredProjects)
          setTimeout(kwicksCallback, 250 * (index + 1) + 900 )  
    else
      removeKwicks($featuredProjects)
        
removeKwicksOnMobileDown = ->
  $featuredProjects = $('.project--featured')
  if ($featuredProjects.length)
    if $(window).width() < 1025
      removeKwicks($featuredProjects)
    else
      initializeKwicks($featuredProjects)


$ ->
  enableMajorProjectsLanding()

$(window).resize ->
  removeKwicksOnMobileDown()
