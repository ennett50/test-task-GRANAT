$(document).ready ->

  query_results = {};
  jquery_string = $('.js-query-string').text().toString();
  current_params = jquery_string.slice(jquery_string.indexOf('?') + 1)
  array_params = current_params.split('&')

  i = 0
  while i < array_params.length
    array_item = array_params[i].split('=')
    console.log(array_item)
    if typeof query_results[array_item[0]] == 'undefined'
      query_results[array_item[0]] = array_item[1]
    else
      query_results[array_item[0]].push array_item[1]
    i++

  $('.js-query-result').text(JSON.stringify(query_results))

