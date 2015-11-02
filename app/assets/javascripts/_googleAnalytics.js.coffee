enableGoogleAnalyticsEvents = () ->
  $trackingLinks = $('.js-tracking-event')
  if $trackingLinks.length
    $headerLinks = $trackingLinks.filter('.primary-navigation__link')
    $headerLinks.click ->
      ga('send', 'event', 'link', 'click', 'primary-navigation')
    $homepageButtons = $trackingLinks.filter('.homepage__link')
    $homepageButtons.click ->
      ga('send', 'event', 'link', 'click', 'home button to ' + $(this).data('target'))

    $socialLinks = $trackingLinks.filter('.social-links__item')
    $socialLinks.click ->
      ga('send', 'event', 'link', 'click', 'footer ' + $(this).attr('title'))
    $localeLinks = $trackingLinks.filter('.locale-picker__link')
    $localeLinks.click ->
      ga('send', 'event', 'link', 'click', 'locale ' + $(this).html())
    $suggestedProject404Link = $trackingLinks.filter('.suggested-project-404')
    $suggestedProject404Link.click ->
      ga('send', 'event', 'link', 'click', 'suggested project 404')
    $backHome404 = $trackingLinks.filter('.back-home-404')
    $backHome404.click ->
      ga('send', 'event', 'link', 'click', 'back home 404')
    $featuredProjectLinks = $trackingLinks.filter('.project--featured__link')
    $featuredProjectLinks.click ->
      ga('send', 'event', 'link', 'click', 'featured project: ' + $(this).data('title'))
    $seeAllProjectsButton = $trackingLinks.filter('.see-all-prokects__button')
    $seeAllProjectsButton.click ->
      ga('send', 'event', 'link', 'click', 'see all projects button')
    $projectFilters = $trackingLinks.filter('.project-filters__button')
    $projectFilters.click ->
      ga('send', 'event', 'link', 'click', 'project filter: ' + $(this).html())
    $allProjectButtons = $trackingLinks.filter('.project--all__button')
    $allProjectButtons.click ->
      ga('send', 'event', 'link', 'click', 'project read more: ' + $(this).data('title'))
    $meOpenPopup = $trackingLinks.filter('.me__summary__open-popup')
    $meOpenPopup.click ->
      ga('send', 'event', 'link', 'click', 'open me popup')
    $meSummaryTopics = $trackingLinks.filter('.me__summary__topic--with-more')
    $meSummaryTopics.click ->
      ga('send', 'event', 'link', 'click', 'topic: ' + $(this).attr('title'))
    $meDownloadResume = $trackingLinks.filter('.me__download-resume__button')
    $meDownloadResume.click ->
      ga('send', 'event', 'link', 'click', 'download resume')
    $singlePorjectLinksButtons = $trackingLinks.filter('.single-project__links__button')
    $singlePorjectLinksButtons.click ->
      ga('send', 'event', 'link', 'click', 'single project link: ' + $(this).attr('href'))
    $singleProjectSuggestedProjectLinks = $trackingLinks.filter('.single-project__suggested-project__link')
    $singleProjectSuggestedProjectLinks.click ->
      ga('send', 'event', 'link', 'click', 'single project related: ' + $(this).data('title'))

$ ->
  enableGoogleAnalyticsEvents()