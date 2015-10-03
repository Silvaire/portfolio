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
    this.currentYear = newActiveEvent.startYear()
    newLocation = null
    newCompany = null
    newStudy = null
    index = newActiveEventIndex
    while (not newLocation or not newCompany or not newStudy) and index >= 0
      lifeEvent = this.lifeEvents[this._array[index]]
      if not lifeEvent.endDate or lifeEvent.endDate >= newActiveEvent.startDate
        location = lifeEvent.location
        company = lifeEvent.company
        study = lifeEvent.study
        if not newLocation and location
          newLocation = location
        if not newCompany and company
          newCompany = company
        if not newStudy and study
          newStudy = study
      index--
    this.currentLocation = newLocation
    this.currentCompany = newCompany
    this.currentStudy = newStudy
    this.displayTimelineMeta()

  displayTimelineMeta: ->
    newYear = "#{this.currentYear}"
    $yearContainer = this.$timeline.find('.timeline__current-year')
    oldYear = $yearContainer.html()
    $locationContainer = this.$timeline.find('.timeline__current-location')
    oldLocation = $locationContainer.html()
    $companyContainer = this.$timeline.find('.timeline__current-company')
    oldCompany = $companyContainer.html()
    $studyContainer = this.$timeline.find('.timeline__current-study')
    oldStudy = $studyContainer.html()
    if oldYear != newYear
      $yearContainer.html(newYear)
    if oldLocation != this.currentLocation
      $locationContainer.html(this.currentLocation)
    if oldCompany != this.currentCompany
      $companyContainer.html(this.currentCompany)
    if oldStudy != this.currentStudy
      $studyContainer.html(this.currentStudy)

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
      $lifeEvents.removeClass('events__item--active')
      $lifeEvent = $('#life-event-' + id);
      $lifeEvent.addClass('events__item--active')


initializeAboutMePage = ->
  $meData = $('.me__data')
  if $meData.length
    window.myLife = new Life 'Silvain'
    $lifeEvents = $('.events__item')
    $lifeEvents.each ->
      window.myLife.addEvent($(this)) # events need to be added chronologically
    window.myLife.initializeAtLatestEvent()
    window.myLife.enableYearLinks()


$ ->  
  initializeAboutMePage()


  