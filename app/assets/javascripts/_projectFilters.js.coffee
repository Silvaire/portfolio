enableProjectFilters = () ->
  $filters = $('.project-filters__button')
  if $filters.length
    $projects = $('.project--major, .project--other')
    $filters.click ->
      $this = $(@)
      $projects.hide()
      if($this.hasClass('project-filters__button--active'))
        $this.removeClass('project-filters__button--active')
      else
        $this.addClass('project-filters__button--active')
      $activeFilters = $filters.filter('.project-filters__button--active')
      if $activeFilters.length
        $activeFilters.each ->
          techId = $this.data('id')
          $projects.filter("[data-techs*='" + techId + "']").show()
      else
        $projects.show()
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