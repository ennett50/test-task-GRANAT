$(document).ready ->

  ###
  # @description - Задание 1
  ###
  queryToString('.js-query-string', '.js-query-result')


  ###
  # @description - Задание 2
  ###
  queryToUrl('.js-object-jquery', '.js-object-result')

  ###
  # @description - Задание 3
  ###

  result = $('#js-compareForms-result')
  differences = compareForms.init($('#form1'), $('#form2'))
  result.empty()
  $.each differences, (i, item) ->
    $('<li>').html(item).appendTo result
    return





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
    arrayitem = array_params[i].split('=')
    if typeof query_results[arrayitem[0]] == 'undefined'
      query_results[arrayitem[0]] = arrayitem[1]
    else
      query_results[arrayitem[0]].push arrayitem[1]
    i++
  $(js_query_result).text(JSON.stringify(query_results))




###
# @description - функция сериализации параметров в query-строку с добавлением к произвольному url.
# @param string js_objectjquery - переменная изменяемого объекта
# @param string js_object_result - переменная вывода результата
###
queryToUrl = (js_objectjquery, js_object_result) ->
  query_object = $(js_objectjquery).text()
  parse_object = JSON.parse(query_object)
  test_location = 'http://example.ru/'
  result = test_location + '?'

  for item of parse_object
    result += item + '=' + parse_object[item] + '&'

  $(js_object_result).text(result.substr(0, result.length - 1))



###
# @description - функция сравнения двух наборов параметров форм
# @param form1 - первая форма для сравнения
# @param form2 - вторая форма для сравнения
###

compareForms =
  ###
  # иницилизация модуля сравнения
  ###
  init : (form1, form2)->

    this.__compare(form1, form2)

  ###
  # модуль сравнения 2х форм
  ###
  __compare : (form1, form2) ->
    differences = []
    form1 = $(form1).serializeArray()
    form2 = $(form2).serializeArray()


    i = 0
    try
      while i < form1.length
        item_form_1 = form1[i]

        j = 0
        while j < form2.length
          item_form_2 = form2[j]


          form1_element = if item_form_1 != null then item_form_1.name else undefined
          form2_element = if item_form_2 != null then item_form_2.name else undefined
          if form1_element == form2_element
            if item_form_1.value != item_form_2.value
              compareForms.__showResult item_form_2.name, item_form_2.value, differences, 'update'
            delete form1[i]
            delete form2[j]

          ++j
        ++i
    catch
      differences = []

    compareForms.__paramsUpdate(differences, form1, form2)
    return differences

  ###
  # Вывод результата сравнения
  ###
  __paramsUpdate: (differences, form1, form2) ->
    if (form1 != null)
      form1.forEach (item) ->
        compareForms.__showResult(item.name, null, differences, 'delete');

    if (form2 != null)
      form2.forEach (item) ->
        compareForms.__showResult(item.name, null, differences, 'insert');

    if (differences.length == 0)
      return 'Формы одинаковы'

  ###
  # показ сообщения результата сравнения
  ###
  __showResult: (nameValue, newValue, differences, type) ->
    textUpdate = 'Обновилось значение - <b>'+ nameValue + '</b> стал <i>' + newValue + '</i>'
    textRemove = 'Удалёно значение  - <b>' + nameValue + '</b>'
    textInsert =  'Добавлено новое значение -  <b>' + nameValue + '</b>'

    if type == null
      type = 'update'
    differences.push if type == 'update' then textUpdate else if type == 'delete' then textRemove else if type == 'insert' then textInsert else undefined






