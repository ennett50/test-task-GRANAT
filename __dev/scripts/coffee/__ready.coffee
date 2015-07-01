$(document).ready ->


  queryToString('.js-query-string', '.js-query-result')
  queryToUrl('.js-object-jquery', '.js-object-result')



  ##################



  #######################################################

  form1 = $('#form1')
  form2 = $('#form2')
  result = $('#task2-result-compareForms')

  run = ->
    res = [].concat(compareForms(form1, form2))
    result.empty()
    $.each res, (i, item) ->
      $('<li>').html(item).appendTo result
      return
    return


  run()


#########################################################################################



window.compareForms = (form1, form2) ->
  differences = undefined


  form1 = $(form1).serializeArray()
  form2 = $(form2).serializeArray()
#  [1, 2, 3].forEach(param) ->
#    console.log(param)
  differences = []
  _i = 0

  while _i < form1.length
    item_in_1 = form1[_i]
    _j = 0

    while _j < form2.length
      item_in_2 = form2[_j]
      if (if item_in_1 != null then item_in_1.name else undefined) == (if item_in_2 != null then item_in_2.name else undefined)
        if item_in_1.value != item_in_2.value
          addToDifferences item_in_2.name, item_in_1.value, item_in_2.value, differences, 'update'
          
        delete form1[_i]
        delete form2[_j]
      ++_j
    ++_i



  form1 = cleanFromEmptiness(form1)
  form2 = cleanFromEmptiness(form2)



  if (form1 != null)
    form1.forEach (param) ->
      addToDifferences(param.name, null, null, differences, 'delete');
#
  if (form2 != null)
    form2.forEach (param) ->
      addToDifferences(param.name, null, null, differences, 'insert');

  if (differences.length == 0)
    return 'Формы идентичны'


  return differences



addToDifferences = (paramName, oldValue, newValue, differences, type) ->
  if type == null
    type = 'update'
  differences.push if type == 'update' then 'Обновился парамметр \'' + paramName + '\': был \'' + oldValue + '\', а стал \'' + newValue + '\'' else if type == 'delete' then 'Удалён парамметр \'' + paramName + '\'' else if type == 'insert' then 'Добавлен новый парамметр: \'' + paramName + '\'' else undefined

cleanFromEmptiness = (array) ->
  array.filter (item) ->
    item




###
# @description - функция разбора query-строки в набор параметров.
# @param string js_query_string - переменная изменяемого объекта
# @param string js_query_result - переменная вывода результата
###
queryToString = (js_query_string, js_query_result) ->
  query_results = {};
  jquery_string = $(js_query_string).text().toString();
  current_params = jquery_string.slice(jquery_string.indexOf('?') + 1)
  array_params = current_params.split('&')
  i = 0
  while i < array_params.length
    array_item = array_params[i].split('=')
    if typeof query_results[array_item[0]] == 'undefined'
      query_results[array_item[0]] = array_item[1]
    else
      query_results[array_item[0]].push array_item[1]
    i++
  $(js_query_result).text(JSON.stringify(query_results))




###
# @description - функция сериализации параметров в query-строку с добавлением к произвольному url.
# @param string js_object_jquery - переменная изменяемого объекта
# @param string js_object_result - переменная вывода результата
###
queryToUrl = (js_object_jquery, js_object_result) ->
  query_object = $(js_object_jquery).text()
  parse_object = JSON.parse(query_object)
  test_location = 'http://example.ru/'
  result = test_location + '?'

  for item of parse_object
    result += item + '=' + parse_object[item] + '&'

  $(js_object_result).text(result.substr(0, result.length - 1))