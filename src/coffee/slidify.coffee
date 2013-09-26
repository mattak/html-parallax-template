###
Inspects the given options and fills out default
values for what's not defined.
###
getSlidifyOptions = (options) ->
  options = options or {}
  options.separator = options.separator or DEFAULT_SLIDE_SEPARATOR
  options.notesSeparator = options.notesSeparator or DEFAULT_NOTES_SEPARATOR
  options.attributes = options.attributes or ""
  options

###
Helper function for constructing a markdown slide.
###
createMarkdownSlide = (content, options) ->
  options = getSlidifyOptions(options)
  notesMatch = content.split(new RegExp(options.notesSeparator, "mgi"))
  content = notesMatch[0] + "<aside class=\"notes\" data-markdown>" + notesMatch[1].trim() + "</aside>"  if notesMatch.length is 2
  marked(content)

###
Parses a data string into multiple slides based
on the passed in separator arguments.
###
slidify = (markdown, options) ->
  options = getSlidifyOptions(options)
  separatorRegex = new RegExp(options.separator + ((if options.verticalSeparator then "|" + options.verticalSeparator else "")), "mg")
  horizontalSeparatorRegex = new RegExp(options.separator)
  matches = undefined
  lastIndex = 0
  isHorizontal = undefined
  wasHorizontal = true
  content = undefined
  sectionStack = []

  # iterate until all blocks between separators are stacked up
  while matches = separatorRegex.exec(markdown)
    notes = null

    # determine direction (horizontal by default)
    isHorizontal = horizontalSeparatorRegex.test(matches[0])

    # create vertical stack
    sectionStack.push []  if not isHorizontal and wasHorizontal

    # pluck slide content from markdown input
    content = markdown.substring(lastIndex, matches.index)
    if isHorizontal and wasHorizontal

      # add to horizontal stack
      sectionStack.push content
    else

      # add to vertical stack
      sectionStack[sectionStack.length - 1].push content
    lastIndex = separatorRegex.lastIndex
    wasHorizontal = isHorizontal

  # add the remaining slide
  ((if wasHorizontal then sectionStack else sectionStack[sectionStack.length - 1])).push markdown.substring(lastIndex)
  markdownSections = ""

  # flatten the hierarchical stack, and insert <section data-markdown> tags
  i = 0
  len = sectionStack.length

  while i < len

    # vertical
    if sectionStack[i].propertyIsEnumerable(length) and typeof sectionStack[i].splice is "function"
      markdownSections += "<section " + options.attributes + "><div class='center'>"
      sectionStack[i].forEach (child) ->
        markdownSections += "<section data-markdown><div class='center'>" + createMarkdownSlide(child, options) + "</div></section>"

      markdownSections += "</section>"
    else
      markdownSections += "<section " + options.attributes + " data-markdown><div class='center'>" + createMarkdownSlide(sectionStack[i], options) + "</div></section>"
    i++
  markdownSections

$.extend
  slidify: slidify

