// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults
//

// Blurb filtering

$.fn.incrementalSearch = function (options) {
  var container = this;
  var timeout;

  var matchAny = function (object, fields, needle) {
    for (var index = 0; index < fields.length; index++) {
      if (object[fields[index]].toLowerCase().indexOf(needle) != -1)
        return true;
    }
    return false;
  };

  var matchQuery = function (object, fields, needles) {
    for (var index = 0; index < needles.length; index++) {
      if (!matchAny(object, fields, needles[index]))
        return false;
    }
    return true;
  };

  var renderResults = function (filter) {
    var list = $('<ul/>');
    var resultCount = 0;
    $.each(options.items, function () {
      if (!filter || filter(this)) {
        list.append(options.render(this));
        resultCount += 1;
      }
    });
    container.html('');
    container.append(list);
    return resultCount;
  };

  var search = function (query) {
    timeout = null;
    $(options.noResults).hide();
    if (query == '') {
      $(options.viewAll).show();
      container.html('');
    } else {
      $(options.viewAll).hide();
      var searchTerms = query.toLowerCase().split(' ');
      var resultCount = renderResults(function (item) {
        return matchQuery(item, options.search, searchTerms)
      });
      if (resultCount == 0)
        $(options.noResults).show();
    }
  };

  $(options.queryInput).keyup(function () {
    var query = $(this).val();
    if (timeout)
      clearTimeout(timeout);
    timeout = setTimeout(function () { search(query) }, 250);
  });

  var removeStart = function () {
    $(options.queryInput).unbind('focus', removeStart);
    $(options.blankSlate).slideUp();
    $(options.searchContainter).removeClass('start', 'fast');
  };

  $(options.queryInput).focus(removeStart);

  $(options.viewAll).click(function () {
    $(this).hide();
    renderResults();
    return false
  });

  return this;
};


// locale dropdown

$('#locale_dropdown .selected').click(function () {
  $('#locale_dropdown .menu').toggle();
  return false;
})

$('#locale_dropdown').click(function (event) {
  event.stopPropagation();
});

$(document).click(function () { $('#locale_dropdown .menu').hide(); });
