enableProjectFilters = () ->
  $filters = $('.project-filters__button')
  if $filters.length
    $projects = $('.project')
    $filters.click ->
      $this = $(@)
      $projects.addClass('project--filtered-out')
      if($this.hasClass('project-filters__button--active'))
        $this.removeClass('project-filters__button--active')
      else
        $this.addClass('project-filters__button--active')
      $activeFilters = $filters.filter('.project-filters__button--active')
      if $activeFilters.length
        $activeFilters.each ->
          $filter = $(this)
          techId = $filter.data('id')
          $projects.filter("[data-techs*='" + techId + ",']").removeClass('project--filtered-out')
      else
        $projects.removeClass('project--filtered-out')
      $this.blur()
      return false


enableStickyFilters = () ->
  $filterSection = $('.project-filters')
  if $filterSection.length
    $nextSection = $filterSection.next()
    $(window).scroll ->
      filterSectionTop = $nextSection.offset().top - $(window).scrollTop()
      if filterSectionTop < 52 + 74 and $('.headroom--unpinned').length
        $filterSection.addClass('sticky')
        $nextSection.addClass('filterSection-placeholder')
      if filterSectionTop > 104 + 74 and $('.headroom--pinned').length
        $filterSection.removeClass('sticky')
        $nextSection.removeClass('filterSection-placeholder')  


$ ->
  enableProjectFilters()
  enableStickyFilters()