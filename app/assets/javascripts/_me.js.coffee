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
    else
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
      $year.data('event-nb', $year.data('event-nb') + 1)
    else
      $years.prepend('<a href="#" class="timeline__year" data-event-nb="1" data-year="' + year + '" id="year-' + year + '">' + year + '</a>')


  updateTimelineMeta: (newActiveEventIndex) ->
    newActiveEvent = this.lifeEvents[this._array[newActiveEventIndex]]
    this.currentEventYear = newActiveEvent.startYear()
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
      $summary.addClass('no-next-event')

    newYear = "#{this.currentEventYear}"
    $yearContainer = this.$timeline.find('.timeline__item--current-year')
    oldYear = $yearContainer.html()

    if oldYear != newYear
      $yearContainer.html(newYear)

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
        $currentTitle.attr('data-title', newValue).addClass('has-title')
      else
        $currentTitle.removeClass('has-title').attr('data-title','')
      if newPreviousValue
        $previousTitle.attr('data-title', newPreviousValue).addClass('has-title')
      else
        $previousTitle.removeClass('has-title').attr('data-title','')
      
      $lineCurrentContainer.attr('data-bg', newBg)
      $linePreviousContainer.attr('data-bg', newPreviousBg)

  goToYear: (year) ->
    if this.years[year] and this.years[year].length
      this.setActiveEvent(this.years[year][0])


  enableYearLinks: ->
    $years = $('.timeline__years')
    if $years.length
      myLife = this
      $years.find('.timeline__year').click ->
        myLife.goToYear($(this).data('year'))
        return false

  displayEventDetails: (id) ->
    $lifeEvents = $('.life-event')
    if not $lifeEvents.filter('#life-event-' + id + '.events__item--active').length
      $lifeEvents.removeClass('events__item--active ' + this.switchSide)
      $lifeEvent = $('#life-event-' + id);
      $lifeEvent.addClass('events__item--active ' + this.switchSide)
      this.switchSide = if this.switchSide.length then '' else 'switch-side'
      # scrollToElement($lifeEvent)

  enableScrollToSwitchEvent: () ->
    myLife = this
    $window = $(window)
    # $window.disablescroll()
    lastScrollTop = 0
    $window.scroll ->
      st = $window.scrollTop()
      if not myLife.changingEvent
        if st > lastScrollTop
          # downscroll code
          previousEventIndex = myLife.getPreviousEventIndex()
          if previousEventIndex != null
            $newActiveEvent = $('#life-event-' + myLife._array[previousEventIndex])
            myLife.changingEvent = true
            $window.disablescroll()
            myLife.setActiveEvent(previousEventIndex)
            window.delay 1500, ->
              myLife.changingEvent = false
              $window.disablescroll('undo')
        else
          # upscroll code
          nextEventIndex = myLife.getNextEventIndex()
          if nextEventIndex != null
            $newActiveEvent = $('#life-event-' + myLife._array[previousEventIndex])
            myLife.changingEvent = true
            $window.disablescroll()
            myLife.setActiveEvent(nextEventIndex)
            window.delay 1500, ->
              myLife.changingEvent = false
              $window.disablescroll('undo')
        lastScrollTop = st
      else
        window.scrollTo(0,lastScrollTop)
        return false 

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
      fittedContainerWidthEm = containerWidthEm * ratio
      $pictureSlices.css({'width':sliceWidthEm + 'em','height':fittedContainerWidthEm + 'em', 'top':(containerHeightEm - fittedContainerWidthEm)/2 + 'em'});
    # for i in [0..9] by 1
    #   $pictureSlices.filter('.life-event__picture__slice--' + i).css({'background-position':'-' + sliceWidthEm * i + 'em 50%','left': sliceWidthEm * i + 'em'})
    


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


  