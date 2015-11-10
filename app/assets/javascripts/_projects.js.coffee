initializeKwicks = ($projects) ->
  $projects.addClass('loaded')
  $kwicks = $('.kwicks')
  $kwicks.filter(':not(.initialized)').kwicks({
    maxSize : '40%',
    behavior: 'menu',
    spacing: 0,
    duration: 400,
    easing: "easeOutCubic"
  })
  $kwicks.addClass('initialized')

removeKwicks = ($projects) ->
  $('.kwicks.initialized').kwicks('destroy').removeClass('initialized')

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

enableStickyProjectCrumbs = () ->
  $crumbs = $('.single-project__content .crumbs')
  if $crumbs.length
    $nextSection = $crumbs.next()
    crumbsHeight = $crumbs.outerHeight()
    $(window).scroll ->
      crumbsTop = $nextSection.offset().top - $(window).scrollTop()
      if crumbsTop < miniHeaderHeight + crumbsHeight and $('.headroom--unpinned').length
        $crumbs.addClass('crumbs--fixed')
        $nextSection.addClass('crumbs-placeholder--active')
      if crumbsTop > headerHeight + crumbsHeight and $('.headroom--pinned').length
        $crumbs.removeClass('crumbs--fixed')
        $nextSection.removeClass('crumbs-placeholder--active')


$ ->
  enableMajorProjectsLanding()
  enableStickyProjectCrumbs()

$(window).resize ->
  removeKwicksOnMobileDown()
