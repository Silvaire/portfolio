enableProjectFilters = () ->
  $filters = $('.project-filters__button')
  if $filters.length
    $projects = $('.project--all')
    $filters.click ->
      $this = $(@)
      $projects.removeClass('project--filtered-out')
      $projects.find('.switch-side').removeClass('switch-side')
      if($this.hasClass('project-filters__button--active'))
        $this.removeClass('project-filters__button--active')
      else
        $this.addClass('project-filters__button--active')
      $activeFilters = $filters.filter('.project-filters__button--active')
      if $activeFilters.length
        $activeFilters.each ->
          $filter = $(this)
          techId = $filter.data('id')
          $projects.filter(":not([data-techs*='" + techId + ",'])").addClass('project--filtered-out')
      # else
      #   $projects.removeClass('project--filtered-out')
      $activeProjects = $projects.filter('.project:not(.project--filtered-out)')
      if $activeProjects.length
        $('.no-project').removeClass('no-project--show')
        $activeProjects.filter('.project--all').each (index, element) ->
          $project = $(this)
          if index % 2 == 0
            $project.find('.text-side, .img-side').addClass('switch-side')
      else
        $('.no-project').addClass('no-project--show')
      $this.blur()
      return false


enableStickyFilters = () ->
  $filterSection = $('.project-filters')
  if $filterSection.length
    $nextSection = $filterSection.next()
    $(window).scroll ->
      filterSectionTop = $nextSection.offset().top - $(window).scrollTop()
      if filterSectionTop < miniHeaderHeight + 71 and $('.headroom--unpinned').length
        $filterSection.addClass('sticky')
        $nextSection.addClass('filterSection-placeholder')
      if filterSectionTop > headerHeight + 71 and $('.headroom--pinned').length
        $filterSection.removeClass('sticky')
        $nextSection.removeClass('filterSection-placeholder')


$ ->
  enableProjectFilters()
  enableStickyFilters()