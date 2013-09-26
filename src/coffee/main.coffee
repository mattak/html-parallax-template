initSlide = () ->
  width  = $(window).width()
  height = $(window).height()

  console.log "w,h: " + width + "," + height

  $.each $("section[data-slide]"), (i) ->
    console.log i
    $(this).css('z-index', i)
    $(this).css('width', width)
    $(this).css('height', height)
    $(this).css('top', i * height)

  $(window).scroll () ->
    dy = $(this).scrollTop()

    # slide scroll effect
    $.each $("section[data-slide]"), (i) ->
      if (dy > i * height)
        y = dy
        x = 0
      else
        y = i * height
        x = (dy * width / height ) % width
      $(this).css("top", y)

  $(window).keydown (e) ->
    # right
    if e.keyCode == 39 || e.keyCode == 40
      $(window).scrollTo "+=#{height}px", 800
    if e.KeyCode == 37 || e.keyCode == 38
      $(window).scrollTo "-=#{height}px", 800

  # rain



$(document).ready ->
  data = $('#markdown').html()

  newdata = $.slidify data,
    separator: '^\n---\n$'
    notesSeparator: 'note:'
    attributes: 'class="slide" data-slide'

  console.log newdata

  $('#preview').html newdata

  initSlide()

#    marked.setOptions
#        gfm: true
#        highlight: (code, lang, callback) ->
#            pygmentize
#                lang: lang
#                format: "html"
#                , code, (err, result) ->
#                    return callback(err)  if err
#                    callback null, result.toString()
#
#        tables: true
#        breaks: false
#        pedantic: false
#        sanitize: true
#        smartLists: true
#        smartypants: false
#        langPrefix: "lang-"

#    marked data, (err, content) ->
#        throw err if err
#        $('#preview').html(content)
#        console.log content

