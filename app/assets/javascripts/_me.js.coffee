Array::include = ((o) ->
  @indexOf(o) isnt -1
)

class LifeEvent
  constructor: (@title) ->

  initializeMeta: ($event) ->
    this.id = $event.data('event-id')
    startDate = $event.data('start-date')
    if startDate.length
      this.startDate = new Date(startDate)
    startMonth = $event.data('start-month')
    if startMonth.length
      this.startMonth = startMonth
    endDate = $event.data('end-date')
    if endDate.length
      this.endDate = new Date(endDate) 
    # this.icon = $event.data('icon')
    # this.introduction = $event.data('introduction')
    # this.description = $event.data('description')
    # this.picture = $event.data('picture')
    # this.links = $event.data('links')
    company = $event.data('company')
    if company.length
      this.company = company
    location = $event.data('location')
    if location.length
      this.location = location
    study = $event.data('study')
    if study.length
      this.study = study
    language = $event.data('language')
    if language.length
      this.language = language
    skills = $event.data('skills')
    if skills.length
      this.skills = skills
    project = $event.data('project')
    if project.length
      this.project = project
    tags = $event.data('tags')
    if tags.length
      this.tags = tags

  startYear: ->
    return this.startDate.getFullYear()

class Life
  constructor: (@name) ->
    this.lifeEvents = {}
    this._array = []
    this.tags = {}
    this.years = {}
    this.$summary = $('.me__summary')
    this.$timeline = $('.timeline')
    this.switchSide = 'switch-side'
    this.changingEvent = false

  initializeAtLatestEvent: () ->
    this.activeEventIndex = 0
    this.setActiveEvent(this._array.length - 1)

  getPreviousEventIndex: () ->
    activeIndex = this.activeEventIndex
    if activeIndex > 0
      return this.activeEventIndex-1
    else
      return null

  getNextEventIndex: () ->
    activeIndex = this.activeEventIndex
    if activeIndex < this._array.length - 1
      return this.activeEventIndex+1
    else
      return null

  getActiveEvent: ->
    return this.lifeEvents[this._array[this.activeEventIndex]]

  setActiveEvent: (index) ->
    if index != null
      if index < 0
        index = 0
      if index > this._array.length - 1
        index = this._array.length - 1
      previousActiveEventIndex = this.activeEventIndex
      this.activeEventIndex = index
      this.movingForward = previousActiveEventIndex <= this.activeEventIndex
      this.updateTimelineMeta(this.activeEventIndex)
      this.updateTimelineYears(this.activeEventIndex)
      if previousActiveEventIndex > this.activeEventIndex
        while previousActiveEventIndex > this.activeEventIndex
          this.hideEventFromSummary(this._array[previousActiveEventIndex])
          previousActiveEventIndex--
      else
        while previousActiveEventIndex < this.activeEventIndex
          previousActiveEventIndex++
          this.showEventInSummary(this._array[previousActiveEventIndex])
      # display the currentEvent
      this.displayEventDetails(this._array[this.activeEventIndex])
    return this.lifeEvents[this._array[this.activeEventIndex]]

  addEvent: ($lifeEvent) ->
    lifeEvent = new LifeEvent($lifeEvent.data('title'))
    lifeEvent.initializeMeta($lifeEvent)
    this.lifeEvents[lifeEvent.id] = lifeEvent
    this._array.push(lifeEvent.id)
    eventIndex = this._array.length - 1
    for tag in lifeEvent.tags
      if this.tags[tag]?
        this.tags[tag].push(eventIndex)
      else
        this.tags[tag] = [eventIndex]
    eventYear = lifeEvent.startDate.getFullYear()
    if this.years[eventYear]?
      this.years[eventYear].push(eventIndex)
      lifeEvent.inYearIndex = this.years[eventYear].length
    else
      lifeEvent.inYearIndex = 1
      this.years[eventYear] = [eventIndex]

    #build here the HTML
    this.addYearToTimeline(eventYear)
    this.addEventToSummary(lifeEvent.id)

  addEventToSummary: (id) ->
    lifeEvent = this.lifeEvents[id]
    if lifeEvent != null
      tags = lifeEvent.tags
      if tags.include? "Work"
        $companiesContainer = this.$summary.find('.me__companies')
        $companiesContainer.prepend('<li class="me__summary__item me__company from-event-' + lifeEvent.id + '">' + lifeEvent.company + '</li>')
      if tags.include? "Studies"
        $studiesContainer = this.$summary.find('.me__studies')
        $studiesContainer.prepend('<li class="me__summary__item me__study from-event-' + lifeEvent.id + '">' + lifeEvent.study + '</li>')
      if tags.include? "Language"
        $languagesContainer = this.$summary.find('.me__languages')
        $languagesContainer.prepend('<li class="me__summary__item me__language from-event-' + lifeEvent.id + '">' + lifeEvent.language + '</li>')
      if tags.include? "Skills"
        $skillsContainer = this.$summary.find('.me__skills')
        $skillsContainer.prepend('<li class="me__summary__item me__skill from-event-' + lifeEvent.id + '">' + lifeEvent.skills + '</li>')
      if tags.include? "Project"
        $projectsContainer = this.$summary.find('.me__projects')
        $projectsContainer.prepend('<li class="me__summary__item me__project from-event-' + lifeEvent.id + '">' + lifeEvent.project + '</li>')
      if tags.include? "Location"
        $locationsContainer = this.$summary.find('.me__locations')
        $locationsContainer.prepend('<li class="me__summary__item me__location from-event-' + lifeEvent.id + '">' + lifeEvent.location + '</li>')
      if tags.include? "Other"
        $otherContainer = this.$summary.find('.me__others')
        $otherContainer.prepend('<li class="me__summary__item me__other from-event-' + lifeEvent.id + '">' + lifeEvent.title + '</li>')
        
  hideEventFromSummary: (id) ->
    $('.from-event-' + id).addClass('me__summary__item--hidden')

  showEventInSummary: (id) ->
    $('.from-event-' + id).removeClass('me__summary__item--hidden')

  addYearToTimeline: (year) ->
    $years = this.$timeline.find('.timeline__years__content')
    $year = $years.find('#year-' + year)
    if $year.length
      $year = $year.first()
      $year.attr('data-event-nb', parseInt($year.attr('data-event-nb')) + 1)
    else
      $years.prepend('<a href="#" class="timeline__year" data-event-nb="1" data-year="' + year + '" id="year-' + year + '">' + year + '<canvas width="150" height="150" class="border-canvas"></canvas></a>')


  updateTimelineMeta: (newActiveEventIndex) ->
    newActiveEvent = this.lifeEvents[this._array[newActiveEventIndex]]
    this.currentEventDate = newActiveEvent.startMonth + '. ' + newActiveEvent.startYear()
    newLocation = null
    newCompany = null
    newStudy = null
    newPreviousLocation = null
    newPreviousCompany = null
    newPreviousStudy = null
    index = newActiveEventIndex
    this.currentEventHasNext = newActiveEventIndex < this._array.length - 1
    this.currentEventHasPrevious = newActiveEventIndex > 0
    currentEventHasLocation = newActiveEvent.location?
    currentEventHasStudy = newActiveEvent.study?
    currentEventHasCompany = newActiveEvent.company?

    updatesTempValues = (value, tempValue, tempPreviousValue, previousIsCurrent) ->
      if not previousIsCurrent and tempValue and not tempPreviousValue
        tempPreviousValue = value
      if not tempValue and value
        tempValue = value
      if previousIsCurrent and tempValue and not tempPreviousValue
        tempPreviousValue = tempValue
      [tempValue,tempPreviousValue]

    while (not newPreviousLocation or not newPreviousCompany or not newPreviousStudy) and index >= 0
      lifeEvent = this.lifeEvents[this._array[index]]
      if not lifeEvent.endDate or lifeEvent.endDate >= newActiveEvent.startDate
        location = lifeEvent.location
        company = lifeEvent.company
        study = lifeEvent.study
        
        [newLocation,newPreviousLocation] = updatesTempValues(location, newLocation, newPreviousLocation, !currentEventHasLocation)
        [newCompany,newPreviousCompany] = updatesTempValues(company, newCompany, newPreviousCompany, !currentEventHasCompany)
        [newStudy,newPreviousStudy] = updatesTempValues(study, newStudy, newPreviousStudy, !currentEventHasStudy)

      index--
    this.currentEventChangesLocation = newLocation != newPreviousLocation
    this.currentEventChangesStudy = newStudy != newPreviousStudy
    this.currentEventChangesCompany = newCompany != newPreviousCompany
    this.currentEventLocation = newLocation
    this.currentEventCompany = newCompany
    this.currentEventStudy = newStudy
    this.currentEventPreviousLocation = newPreviousLocation
    this.currentEventPreviousCompany = newPreviousCompany
    this.currentEventPreviousStudy = newPreviousStudy
    this.displayTimelineMeta()

  displayTimelineMeta: ->
    $summary = this.$timeline.find('.timeline__summary')
    if this.currentEventHasPrevious
      $summary.removeClass('no-previous-event')
    else 
      $summary.addClass('no-previous-event')
    if this.currentEventHasNext
      $summary.removeClass('no-next-event')
    else
      window.delay 500, -> # delay to change value in the middle of the scrolling animation
        $summary.addClass('no-next-event')

    newDate = "#{this.currentEventDate}"
    $dateContainer = this.$timeline.find('.timeline__item--current-date')
    oldDate = $dateContainer.html()

    if oldDate != newDate
      window.delay 500, -> # delay to change value in the middle of the scrolling animation
        $dateContainer.html(newDate)

    this.updateMetaLine('location', this.currentEventLocation, this.currentEventPreviousLocation, this.currentEventChangesLocation)
    this.updateMetaLine('company', this.currentEventCompany, this.currentEventPreviousCompany, this.currentEventChangesCompany)
    this.updateMetaLine('study', this.currentEventStudy, this.currentEventPreviousStudy, this.currentEventChangesStudy)

  updateMetaLine: (type, newValue, newPreviousValue, valueChanges) ->
    $lineCurrentContainer = this.$timeline.find('.timeline__item--current-' + type)
    $currentTitle = $lineCurrentContainer.find('.timeline__item__title')
    $linePreviousContainer = this.$timeline.find('.timeline__item--previous-' + type)
    $previousTitle = $linePreviousContainer.find('.timeline__item__title')
    lineCurrentBg = $lineCurrentContainer.attr('data-bg')
    linePreviousBg = $linePreviousContainer.attr('data-bg')
    oldCurrentValue = $currentTitle.attr('data-title')
    oldPreviousValue = $previousTitle.attr('data-title')
    if oldCurrentValue != newValue or oldPreviousValue != newPreviousValue
      # displays the "previous value" part or not
      # if valueChanges
      #   $linePreviousContainer.removeClass('timeline__item--hidden')
      # else
      #   $linePreviousContainer.addClass('timeline__item--hidden')
      # adjusts the bg colors
      newBg = if newValue then 1 else 0
      newPreviousBg = if newPreviousValue then 2 else 0
      if this.movingForward
        if newPreviousValue == oldCurrentValue and lineCurrentBg
          newPreviousBg = lineCurrentBg
        if newPreviousValue == newValue
          newBg = newPreviousBg
        else if newValue
          newBg = newPreviousBg % 2 + 1
      else
        if oldPreviousValue == newValue and linePreviousBg
          newBg = linePreviousBg
        if newValue == newPreviousValue
          newPreviousBg = newBg
        else if newPreviousValue
          newPreviousBg = newBg % 2 + 1

      if newValue
        window.delay 500, -> # delay to change value in the middle of the scrolling animation
          $currentTitle.attr('data-title', newValue).addClass('has-title')
      else
        window.delay 500, -> # delay to change value in the middle of the scrolling animation
          $currentTitle.removeClass('has-title').attr('data-title','')
      if newPreviousValue
        window.delay 500, -> # delay to change value in the middle of the scrolling animation
          $previousTitle.attr('data-title', newPreviousValue).addClass('has-title')
      else
        window.delay 500, -> # delay to change value in the middle of the scrolling animation
          $previousTitle.removeClass('has-title').attr('data-title','')
      
      window.delay 500, -> # delay to change value in the middle of the scrolling animation
        $lineCurrentContainer.attr('data-bg', newBg)
        $linePreviousContainer.attr('data-bg', newPreviousBg)

  goToYear: (year) ->
    if this.years[year] and this.years[year].length
      scrollToElement(this.$timeline)
      this.setActiveEvent(this.years[year][0])


  enableYearLinks: ->
    $years = $('.timeline__years')
    if $years.length
      myLife = this
      $years.find('.timeline__year').click ->
        myLife.goToYear($(this).data('year'))
        return false

  updateTimelineYears: (currentEventIndex) ->
    currentEvent = this.lifeEvents[this._array[currentEventIndex]]
    year = currentEvent.startYear()
    $timelineYears = $('.timeline__year')
    $timelineYears.removeClass('timeline__year--active')
    $newYear = $timelineYears.filter('[data-year=' + year + ']')
    $newYear.addClass('timeline__year--active');
    eventInNewYear = $newYear.data('event-nb')
    inYearIndex = currentEvent.inYearIndex
    $('.border-canvas').removeClass('border-canvas--active').each ->
      canvas = $(this)[0]
      context = canvas.getContext('2d')
      context.clearRect(0, 0, canvas.width, canvas.height)
    $canvas = $('.timeline__year--active .border-canvas')
    $canvas.addClass('border-canvas--active')
    canvas = $canvas[0]
    context = canvas.getContext('2d')
    centerX = canvas.width / 2
    centerY = canvas.height / 2
    radius = (canvas.width / 2) - 3

    # grey circle on activation
    context.beginPath()
    context.lineWidth = 4
    context.imageSmoothingEnabled = true
    context.strokeStyle = '#ccc'
    context.arc(centerX, centerY, radius, 0, 2 * Math.PI, false)
    context.stroke()


    context.beginPath()
    context.strokeStyle = '#044C29'
    context.imageSmoothingEnabled = true
    if this.movingForward
      endValue = (2 * Math.PI * (inYearIndex-1)/eventInNewYear) - (Math.PI / 2)
      curPerc = ((inYearIndex-1)/eventInNewYear * 100) + 5
      endPercent = inYearIndex/eventInNewYear * 100
    else
      endValue = (2 * Math.PI * (inYearIndex+1)/eventInNewYear) - (Math.PI / 2)
      curPerc = ((inYearIndex+1)/eventInNewYear * 100)
      endPercent = (inYearIndex/eventInNewYear * 100) + 5
    context.arc(centerX, centerY, radius, -(Math.PI / 2) , endValue, false)
    context.stroke()

    animate = (current, forward) ->
      context.beginPath()
      context.imageSmoothingEnabled = true
      if forward or eventInNewYear == 1
        context.strokeStyle = '#044C29'
        curPerc = curPerc + 5
      else
        context.strokeStyle = '#ccc'
        curPerc = curPerc - 5
      context.arc(centerX, centerY, radius, 2 * (current-0.05) * Math.PI - (Math.PI / 2), 2 * current * Math.PI - (Math.PI / 2), false)
      context.stroke()
      if (forward and curPerc <= endPercent) or (not forward and curPerc >= endPercent)
        if $canvas.hasClass('border-canvas--active')
          requestAnimationFrame ->
            animate(curPerc/100, forward)
        else
          context.clearRect(0, 0, canvas.width, canvas.height)
    animate(curPerc/100, this.movingForward)

  displayEventDetails: (id) ->
    $lifeEvents = $('.life-event')
    if not $lifeEvents.filter('#life-event-' + id + '.events__item--active').length
      $lifeEvents.removeClass('events__item--active ' + this.switchSide)
      $lifeEvent = $('#life-event-' + id);
      $lifeEvent.addClass('events__item--active ' + this.switchSide)
      this.switchSide = if this.switchSide.length then '' else 'switch-side'

  enableScrollToSwitchEvent: () ->
    myLife = this
    $timeline = myLife.$timeline
    $window = $(window)
    scrollKeys = {32: 1, 33: 1, 34: 1, 35: 1, 36: 1, 37: 1, 38: 1, 39: 1, 40: 1}
    
    preventScrolling = (e) ->
      e = e || window.event
      if e.preventDefault
        e.preventDefault()
      e.returnValue = false
      updatesTimelineAccordingToScrollDirection(e)

    preventScrollingForKeys = (e) ->
      if (scrollKeys[e.keyCode])
        if e.preventDefault
          e.preventDefault()
        e.returnValue = false
        updatesTimelineAccordingToScrollDirection(e)

    updatesTimelineAccordingToScrollDirection = (e) ->
      if not myLife.changingEvent
        myLife.changingEvent = true
        $aboutSection = $('.section--about')
        $dateContainer = $('.timeline__date-container')
        # $currentMetaLines = $('.timeline__item--current')
        $previousMetaLines = $('.timeline__item--previous')
        # windowScrollTop = $(window).scrollTop()
        if e.deltaY > 0 or e.keyCode in [32,34,35,39,40]
          # downscroll code
          if $aboutSection.hasClass('at-top')
            scrollToElement($timeline)
            $aboutSection.removeClass('at-top').addClass('at-timeline')
            window.delay 1500, ->
              myLife.changingEvent = false
          else
            previousEventIndex = myLife.getPreviousEventIndex()
            if previousEventIndex != null #and windowScrollTop < $timeline.offset().top
              $newActiveEvent = $('#life-event-' + myLife._array[previousEventIndex])
              myLife.setActiveEvent(previousEventIndex)
              if myLife.currentEventHasPrevious
                # $currentMetaLines.addClass('current-scroll-backwards')
                $previousMetaLines.addClass('previous-scroll-backwards')
                $dateContainer.addClass('date-scroll-backwards')
              else
                # $currentMetaLines.addClass('first-current-scroll-backwards')
                $previousMetaLines.addClass('first-previous-scroll-backwards')
                $dateContainer.addClass('first-date-scroll-backwards')
              window.delay 1000, ->
                # $currentMetaLines.removeClass('current-scroll-backwards').removeClass('first-current-scroll-backwards')
                $previousMetaLines.removeClass('previous-scroll-backwards').removeClass('first-previous-scroll-backwards')
                $dateContainer.removeClass('date-scroll-backwards').removeClass('first-date-scroll-backwards')
                myLife.changingEvent = false
            else
              scrollToElement('#bottom')
              $aboutSection.removeClass('at-timeline').addClass('at-bottom')
              window.delay 1500, ->
                myLife.changingEvent = false
        else
          # upscroll code
          if $aboutSection.hasClass('at-bottom') and $timeline.offset().top < $(window).scrollTop()
            scrollToElement($timeline)
            $aboutSection.removeClass('at-bottom').addClass('at-timeline')
            window.delay 1500, ->
                myLife.changingEvent = false
          else
            nextEventIndex = myLife.getNextEventIndex()
            if nextEventIndex != null #and windowScrollTop + $window.height() > $timeline.offset().top
              $newActiveEvent = $('#life-event-' + myLife._array[previousEventIndex])
              if myLife.currentEventHasPrevious
                # $currentMetaLines.addClass('current-scroll-forward')
                $previousMetaLines.addClass('previous-scroll-forward')
                $dateContainer.addClass('date-scroll-forward')
              else
                # $currentMetaLines.addClass('first-current-scroll-forward')
                $previousMetaLines.addClass('first-previous-scroll-forward')
                $dateContainer.addClass('first-date-scroll-forward')
              myLife.setActiveEvent(nextEventIndex)
              window.delay 1000, ->
                # $currentMetaLines.removeClass('current-scroll-forward').removeClass('first-current-scroll-forward')
                $previousMetaLines.removeClass('previous-scroll-forward').removeClass('first-previous-scroll-forward')
                $dateContainer.removeClass('date-scroll-forward').removeClass('first-date-scroll-forward')
                myLife.changingEvent = false
            else
              scrollToElement('#top')
              $aboutSection.removeClass('at-bottom').removeClass('at-timeline').addClass('at-top')
              window.delay 1500, ->
                myLife.changingEvent = false
      return false

    $('body').addClass('scroll-locked')

    if (window.addEventListener) # older FF
      window.addEventListener('DOMMouseScroll', preventScrolling, false)
    window.onwheel = preventScrolling # modern standard
    window.onmousewheel = document.onmousewheel = preventScrolling # older browsers, IE
    window.ontouchmove  = preventScrolling # mobile
    document.onkeydown  = preventScrollingForKeys
    # $window.scroll ->
    #   st = $window.scrollTop()
      # if not myLife.changingEvent
      #   if st > lastScrollTop
      #     # downscroll code
      #     previousEventIndex = myLife.getPreviousEventIndex()
      #     if previousEventIndex != null
      #       $newActiveEvent = $('#life-event-' + myLife._array[previousEventIndex])
      #       $window.disablescroll()
      #       myLife.setActiveEvent(previousEventIndex)
      #       window.delay 1500, ->
      #         myLife.changingEvent = false
      #         $window.disablescroll('undo')
      #   else
      #     # upscroll code
      #     nextEventIndex = myLife.getNextEventIndex()
      #     if nextEventIndex != null
      #       $newActiveEvent = $('#life-event-' + myLife._array[previousEventIndex])
      #       $window.disablescroll()
      #       myLife.setActiveEvent(nextEventIndex)
      #       window.delay 1500, ->
      #         myLife.changingEvent = false
      #         $window.disablescroll('undo')
      #   lastScrollTop = st
    #   else
    #     window.scrollTo(0,lastScrollTop)
    #     return false 

setEventPictureSlicesCss = ->
  $pictureContainers = $('.life-event__picture')
  if $pictureContainers.length
    $activePictureContainer = $('.events__item--active .life-event__picture')
    activePictureContainerFontSize = parseFloat($activePictureContainer.css("font-size"))
    containerWidthEm = $activePictureContainer.width() / activePictureContainerFontSize
    containerHeightEm = $activePictureContainer.height() / activePictureContainerFontSize
    sliceWidthEm = containerWidthEm / 10
    $pictureContainers.each ->
      $this = $(this)
      $pictureFile = $this.find('.life-event__picture-file')
      url = $pictureFile.attr('src')
      ratio = $pictureFile.height() / $pictureFile.width()
      for i in [0..9] by 1
        $this.append('<div class="life-event__picture__slice life-event__picture__slice--' + i + '" style="background-image:url(\'' + url + '\');background-position:-' + sliceWidthEm * i + 'em 50%;left:' + sliceWidthEm * i + 'em;"></div>')
      $pictureSlices = $this.find('.life-event__picture__slice')
      fittedContainerWidthEm = Math.max(containerWidthEm * ratio, containerHeightEm) # in case the section is too high for the picture, makes the picture even bigger
      $pictureSlices.css({'width':sliceWidthEm + 0.2 + 'em','height':fittedContainerWidthEm + 'em', 'top':(containerHeightEm - fittedContainerWidthEm)/2 + 'em'}) # adds 0.2 em for overlap, so that there's never a white pixel
    


initializeAboutMePage = ->
  $meData = $('.me__data')
  if $meData.length
    window.myLife = new Life 'Silvain'
    $lifeEvents = $('.events__item')
    $lifeEvents.each ->
      window.myLife.addEvent($(this)) # events need to be added chronologically
    window.myLife.initializeAtLatestEvent()
    window.myLife.enableYearLinks()
    window.myLife.enableScrollToSwitchEvent()
    if window.windowHasLoaded # check if the window had already finished loading
      setEventPictureSlicesCss() 
    else
      $(window).load ->
        setEventPictureSlicesCss()
    


$ ->  
  initializeAboutMePage()

$(window).resize ->
  setEventPictureSlicesCss()


  