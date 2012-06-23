$.fn.incrementalSearch = (options) ->
  timeout = undefined
  matchAny = (object, fields, needle) ->
    index = 0

    while index < fields.length
      return true  unless object[fields[index]].toLowerCase().indexOf(needle) is -1
      index++
    false

  matchQuery = (object, fields, needles) ->
    index = 0

    while index < needles.length
      return false  unless matchAny(object, fields, needles[index])
      index++
    true

  renderResults = (filter) =>
    list = $("<ul/>")
    resultCount = 0
    $.each options.items, ->
      if not filter or filter(this)
        list.append options.render(this)
        resultCount += 1

    @html ""
    @append list
    resultCount

  search = (query) =>
    timeout = null
    $(options.noResults).hide()
    if query is ""
      $(options.viewAll).show()
      @html ""
    else
      $(options.viewAll).hide()
      searchTerms = query.toLowerCase().split(" ")
      resultCount = renderResults((item) ->
        matchQuery item, options.search, searchTerms
      )
      $(options.noResults).show()  if resultCount is 0

  $(options.queryInput).keyup ->
    query = $(this).val()
    clearTimeout timeout  if timeout
    timeout = setTimeout(->
      search query
    , 250)

  removeStart = ->
    $(options.queryInput).unbind "focus", removeStart
    $(options.blankSlate).slideUp()
    $(options.searchContainter).removeClass "start", "fast"

  $(options.queryInput).focus removeStart
  $(options.viewAll).click ->
    $(this).hide()
    renderResults()
    false

  return @
