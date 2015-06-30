$(document).ready ->

	$('.js-call-me').click ->
		$('.header-info_dropdown').toggle()

	$('.js-btn-up').click ->
		$('html:not(:animated),body:not(:animated)').animate { scrollTop: 0 }, 500
		false

	$('body').on 'change', '.js-entity-checkbox', (e) ->
		e.preventDefault()
		if this.checked
			$(this).closest('.popup').addClass('__entity')
		else
			$(this).closest('.popup').removeClass('__entity')
		return

	$('body').on 'click', '.js-form-show_password', (e) ->
		e.preventDefault()
		$form = $(this).closest('.js-form').toggleClass('__showpassword')

		if (_$password = $form.find('[type="password"]')).length > 0
			_$password.addClass('_expassword').attr 'type', 'text'
		else if (_$password = $form.find('._expassword')).length > 0
			_$password.removeClass('_expassword').attr 'type', 'password'



		return



	top_show = 250
	show_scrollTop = ->
		if $(window).scrollTop() > top_show then $('.js-btn-up').fadeIn(600) else $('.js-btn-up').hide()
	$(window).scroll ->
		show_scrollTop()

	show_scrollTop();



	tabs()
	grid()
	cabinet()
	form()
	toggleClass()
	comparison()
	filter()
	range()
	catalog()
	filterChanges()
	product()
	classAction()
	productGallery()
	return

toggleClass = ->
	_toggle = ($target, classnames) ->
		for _classname in classnames
			$target.toggleClass _classname
		return
	_parseTarget = (targetSelector, $self) ->
		if targetSelector.toLowerCase() == 'this'
			return $self
		else
			return $(targetSelector)

	_parseStr = (str) ->
		_result = str
		_result = _result.replace(/ /g,'')
		if (_indexof = _result.indexOf(',')) > 0 && _indexof < (_result.length - 1)
			_result = _result.split(',')
		else
			_result = [_result]
		return _result

	$('body').on 'click', '[data-toggle-class]', (e) ->
		e.preventDefault()

		_$this = $(this)

		classnames = _parseStr _$this.attr('data-toggle-class')
		targets = [ 'this' ]

		if _$this.hasAttr 'data-toggle-class-target'
			targets = _parseStr _$this.attr('data-toggle-class-target')

		for target in targets
			_toggle _parseTarget(target, _$this), classnames

		return
	return


tabs = ->
	$('body').on 'click', '[data-tab]', (e) ->
		e.preventDefault()

		$this = $(this)

		if $this.hasClass '__current' then return

		$group = $( '[data-tab="' + $this.attr('data-tab') + '"]' )

		$target = $( $this.attr 'href' )

		$group.each ->
			$( $(this).removeClass('__current').attr('href') ).removeClass('__current')

		$this.addClass '__current'

		$target.addClass '__current'

		doRefreshUI()
		return
	return

grid = ->
	$('.grid-row').cleanWhitespace()
	$('.grid-row').addClass '__cleared'

doRefreshUI grid

myMap = null

mapInit = ->
	if $('#adressMap').length < 1 then return
	myMap = new ymaps.Map('adressMap', {
		center: [55.76, 37.64],
		zoom: 10
	});

ymaps.ready(mapInit)



cabinet = ->
	$('body').on 'click', '.js-cabinet-person_edit', (e) ->
		e.preventDefault()
		$(this).closest('form').addClass('__isEdit').find('[disabled]').removeAttr('disabled')



		return


	$('body').on 'click', '.js-cabinet-adress_edit', (e) ->
		e.preventDefault()
		$(this).closest('.js-cabinet-adress_item').addClass('__isEdit').find('[disabled]').removeAttr('disabled')
		return


	$('body').on 'click', '.js-cabinet-adress_add', (e) ->
		e.preventDefault()
		$blank = $(this).closest('.js-cabinet-adress').find('.__isBlank')

		$blank.before $blank.clone().removeClass('__isBlank')


		return

	return

form = ->
	$('input[type="checkbox"]:not(._inited):not(._default)').each ->
		$(this).addClass('_inited').button().button( "widget" ).addClass('ui-type-checkbox')
		return


	$('input[type="radio"]:not(._inited):not(._default)').each ->
		$(this).addClass('_inited').button().button( "widget" ).addClass('ui-type-radio')
		return

	$('select:not(._inited):not(._default)').each ->
		$(this).addClass('_inited').selectmenu()

	return


doRefreshUI form


comparison = ->
	$('.comparison-right_wrapper').addClass('__cleared').find('.comparison-right_wrapper-panel').cleanWhitespace()
	$roller = $('.js-comparison-slider_roller')



	_getItemWidth = ->
		return $('.js-comparison-right_wrapper-panel:first').find('.js-comparison-item:first').outerWidth(true)
		# return 200
	_getCountElements = ->
		return $('.js-comparison-right_wrapper-panel:first').find('.js-comparison-item').length
		# return 9
	_getCountInPage = ->
		return 4

	_isPressed = do ->
		_pressed = false

		return (_ispress) ->
			if _ispress == true || _ispress == false
				_pressed = _ispress
			else
				return _pressed


	_currentIndex = do ->
		_curInd = 0
		_self =
			get: ->
				_left = parseInt ($('.js-comparison-right_wrapper-panel:first').css('left') || 0)
				if _left == 0 then return 0
				if _left < 0 then _left = -_left

				return  Math.round( _left/_getItemWidth() )
			set: (newIndex) ->
				if newIndex < 0 then newIndex = 0
				if newIndex >= ( _getCountElements() - _getCountInPage() )
					newIndex = _getCountElements() - _getCountInPage()
				if _getCountElements() <= _getCountInPage()
					newIndex = 0
				_curInd = newIndex
				return _curInd

		return _self


	_setIndexHandle = (index) ->
		index = _currentIndex.set index

		_left = -( index*_getItemWidth() )

		$('.comparison-right_wrapper-panel').css 'left', _left
		_rollerOffset.set index/(_getCountElements() - _getCountInPage())

	_prevButtonHandle = (e) ->
		e.preventDefault()
		_setIndexHandle (_currentIndex.get() - 1)
		return

	_nextButtonHandle = (e) ->
		e.preventDefault()
		_setIndexHandle (_currentIndex.get() + 1)
		return

	_mouseOffset = do ->
		_startPosition = 0
		_currentPosition = 0

		_self = (_newPos) ->
			if _newPos? && typeof _newPos == "number"
				_currentPosition = _newPos

			return ( _currentPosition - _startPosition )

		_self.start = (_startPos) ->
			if _startPos? && typeof _startPos == "number"
				_startPosition = _startPos
			return

		return _self

	_rollerOffset = do ->
		_startPosition = 0
		_currentPosition = 0
		_$roller = $roller
		_$parent = $('.js-comparison-slider_roller').parent()
		_maxLeft = 0
		_width = _$roller.width()
		_parentWidth = _$parent.width()
		_maxLeft = _parentWidth - _width

		_checkPos = (_pos) ->
			if _pos < 0 then _pos = 0

			if _pos > _maxLeft then _pos = _maxLeft

			return _pos

		_self = (_newPos) ->
			if !_newPos? then return
			_newPos = _startPosition + _newPos
			_newPos = _checkPos _newPos

			if _newPos == _currentPosition then return false

			_currentPosition = _newPos

			return _currentPosition


		_self.start = (_$obj) ->
			_width = _$roller.width()
			_parentWidth = _$parent.width()
			_maxLeft = _parentWidth - _width

			_startPosition = parseInt _$roller.css('left')
			return

		_self.percent = ->
			if _currentPosition == 0
				return 0
			else
				return _currentPosition/_maxLeft
		_self.set = (percent) ->
			_width = _$roller.width()
			_parentWidth = _$parent.width()
			_maxLeft = _parentWidth - _width

			_$roller.css 'left', _maxLeft*percent

		_self.setPos = (_newLef) ->
			_width = _$roller.width()
			_parentWidth = _$parent.width()
			_maxLeft = _parentWidth - _width

			_currentPosition = _checkPos _newLef
			_$roller.css 'left', _currentPosition
			return


		return _self


	_moveHandle = (e) ->
		if !_isPressed() then return
		_moveLeft = _rollerOffset _mouseOffset e.clientX
		$roller.css 'left', _moveLeft
		_movePanel _rollerOffset.percent()

	_rollerPressHandle = (e) ->
		_isPressed true
		$('body').addClass '__move'
		$('body').on 'mouseup', _rollerReleaseHandle
		_mouseOffset.start e.clientX
		_rollerOffset.start()

	_rollerReleaseHandle = ->
		_isPressed false
		$('body').removeClass '__move'


	_movePanel = do ->
		_lastPercent = 0

		_self = (percent) ->
			if _lastPercent == percent then return
			_lastPercent = percent

			$('.comparison-right_wrapper-panel').css 'left', -( ( _getCountElements() - _getCountInPage() )*_getItemWidth()*_lastPercent)

			return
		_self.clear = ->
			_lastPercent = -1

		return _self

	sliderClickHandle = (e) ->
		if !$(e.target).is('.js-comparison-slider') then return
		e.preventDefault()

		_rollerOffset.setPos e.offsetX
		_movePanel.clear()
		_movePanel _rollerOffset.percent()

	clickRemoveHandle = (e) ->
		e.preventDefault()
		_index = $(this).closest('.js-comparison-item').index()
		$('.js-comparison-right_wrapper-panel').each ->
      $($(this).children()[_index]).remove();

		do _refresh


	$('body').on 'click', '.js-comparison-slider_next', _nextButtonHandle
	$('body').on 'click', '.js-comparison-slider_prev', _prevButtonHandle
	$('body').on 'mousemove', _moveHandle
	$('body').on 'mousedown', '.js-comparison-slider_roller', _rollerPressHandle
	$('body').on 'click', '.js-comparison-slider', sliderClickHandle
	$('body').on 'click', '.js-catalog-items_remove', clickRemoveHandle


	_calcRoller = ->
		_rollerWidth = ( _getCountInPage()*100/_getCountElements() )
		if _rollerWidth > 100 then _rollerWidth = 100
		if _rollerWidth == 100
			$('.js-comparison-slider').addClass '__disabled'
		else
			$('.js-comparison-slider').removeClass '__disabled'

		$('.js-comparison-slider_roller').css
			'width': _rollerWidth.toFixed(2) + "%"

	_lineBackground = ->
		_lineIndex = 0
		$('.js-comparison-right_line').each ->
			_$line = $(this)
			if _$line.hasClass '__title'
				_lineIndex = 0
				return

			if _$line.hasClass '__hidden'
				return

			if _lineIndex%2 != 0
				_$line.addClass '__gray'
			else
				_$line.removeClass '__gray'

			_lineIndex++
			return

	_hideIdentical = (_hide) ->
		if _hide
			$('.js-comparison-right_line.__identical').addClass('__hidden').hide()
		else
			$('.js-comparison-right_line.__identical').removeClass('__hidden').show()

	_refreshIdentical = ->
		_hideIdentical false
		if $('.js-comparison-show[data-comparison="different"]:checked').length > 0
			_hideIdentical true



	$('body').on 'change', '.js-comparison-show', ->
		_hideIdentical( $(this).attr('data-comparison') == 'different' )
		_lineBackground()

	_identical = ->
		$('.js-comparison-row-options').find('.js-comparison-right_line.__option').each ->
			_$line = $(this)
			_$items = _$line.find('.js-comparison-item')
			_lastValue = false
			_isDifferent = false
			_$items.each ->
				_text = $(this).text().replace(/\s+/g, '').toLowerCase()
				if _lastValue == false
					_lastValue = _text
					return
				if _text != _lastValue
					_isDifferent = true
					return false

			if _isDifferent
				_$line.removeClass '__identical'
			else
				_$line.addClass '__identical'
			return

		return


	_refresh = ->
		do _identical
		do _refreshIdentical
		do _calcRoller
		do _lineBackground
		_setIndexHandle _currentIndex.get()

		return

	do _refresh

	comparison = _refresh

	return _refresh

filter = ->
	$('body').on 'click', '.js-filter-item_head-label', (e) ->
		e.preventDefault()
		$(this).closest('.js-filter-item').toggleClass('__open')

range = ->
	$('body').on 'reset', 'form', ->
		$(this).find('.js-range.__inited').each ->
			$(this).trigger 'sliderreset'


	$('.js-range:not(.__inited)').addClass('__inited').each ->
		_$range = $(this)

		_setInputValues = (values) ->
			if _options.minInput
				if _options.minInput.val() + "" != values[0] + ""
					_options.minInput.val values[0]
					_options.minInput.trigger({type:"change", sliderchanged:true})
			if _options.maxInput
				if _options.maxInput.val() + "" != values[1] + ""
					_options.maxInput.val values[1]
					_options.maxInput.trigger({type:"change", sliderchanged:true})

		_slideHandle = (event, ui) ->
			_setInputValues ui.values

		_changeHandle = (event, ui) ->
			setTimeout ->
				_slideHandle event, ui
			, 1

		_createHandle = (event, ui) ->
			_options.leftLabel = $('<div class="ui-slider-label-left"></div>')
			_options.middleLabel = $('<div class="ui-slider-label-middle"></div>')
			_options.rightLabel = $('<div class="ui-slider-label-right"></div>')
			_options.leftLabel.html _options.min
			_options.rightLabel.html _options.max
			_options.middleLabel.html Math.round( ( _options.min + ( (_options.max - _options.min) / 2 ) )*100 )/100
			_$range.append _options.leftLabel
			_$range.append _options.rightLabel
			_$range.append _options.middleLabel

		_minChangeHandle = (e) ->
			if e.sliderchanged == true
				return
			_tmp = parseFloat $(this).val()
			if _tmp + "" == "NaN"
				_tmp = _options.min
			_$range.slider "values", [ _tmp, _$range.slider("values")[1] ]

		_maxChangeHandle = (e) ->
			if e.sliderchanged == true
				return
			_tmp = parseFloat $(this).val()
			if _tmp + "" == "NaN"
				_tmp = _options.max
			_$range.slider "values", [ _$range.slider("values")[0], _tmp ]

		_resetHandle = ->
			_$range.slider "values", [ _options.min, _options.max ]

		_options =
			range: true
			min: 0
			max: 1000
			values: [0, 1000]
			slide: _slideHandle
			change: _changeHandle
			step: 1
			minInput: false
			maxInput: false
			leftLabel: false
			rightLabel: false
			middleLabel: false
			create: _createHandle

		_tmp = _$range.attr 'data-range-min'
		if _tmp?
			_options.min = parseFloat _tmp

		_tmp = _$range.attr 'data-range-max'
		if _tmp?
			_options.max = parseFloat _tmp

		_options.values = [_options.min, _options.max]

		_tmp = _$range.attr 'data-range-step'
		if _tmp?
			_options.step = parseFloat _tmp

		_tmp = _$range.parent().find('.js-range_min')
		if _tmp.length > 0
			_options.minInput = _tmp
			_options.minInput.on 'change', _minChangeHandle

		_tmp = _$range.parent().find('.js-range_max')
		if _tmp.length > 0
			_options.maxInput = _tmp
			_options.maxInput.on 'change', _maxChangeHandle

		_$range = _$range.slider _options

		_$range.on 'sliderreset', _resetHandle

		_$range.data 'slider',
			options: _options
			element: _$range

		_setInputValues [_options.min, _options.max]

		return
	return

doRefreshUI range

catalog = ->
	$('body').on 'click', '.js-catalog-items_options-more', (e) ->
		e.preventDefault()
		_$this = $(this)
		_$this.closest('.js-catalog-items_options').find('.__hidden').removeClass('__hidden')
		_$this.remove()
		return
	$('body').on 'click', '.js-catalog-items_ajax', (e) ->
		e.preventDefault()
		$(this).closest('.catalog-items_item').addClass('__loading')
		return


	$('body').on 'click', '.js-catalog-items_tocart', (e) ->
		e.preventDefault()
		$btn = $(this)
		if $btn.hasAttr 'disabled' then return
		$btn.attr 'disabled', 'true'
		$btn.css
			'width': $btn.outerWidth()
			'font-weight': '400'
		$btn.data 'original-html', $btn.html()
		$btn.html 'Добавляю...'
		$btn.addClass '__blue'
		$btn.addClass '__loading'
		setTimeout ->
			$btn.css
				'width': ''
				'font-weight': ''
			$btn.removeClass '__blue'
			$btn.removeClass '__loading'
			$btn.html $btn.data 'original-html'
			$btn.data 'original-html', ''
			$btn.removeAttr 'disabled'
			cartMessage.show $btn
		, 1000
		return
	return

cartMessage = do ->
	_$messageTemplate = $('<div class="catalog-message">Товар добавлен!</div>')

	_getParameters = ($obj) ->
		_offset = $obj.offset()
		_result =
			width: $obj.outerWidth()
			height: $obj.outerHeight()
			top: _offset.top
			left: _offset.left

		return _result

	_getMainBlock = ->
		_res = $('main')
		if _res.length < 1
			return $('body')
		return _res


	_showHandle = ($btn) ->
		_$message = _$messageTemplate.clone()
		_params = _getParameters $btn
		_getMainBlock().append _$message
		_$message.css
			'left': _params.left
			'top': (_params.top - _$message.outerHeight() )
			'width': _params.width
			'display': 'none'
		_$message.fadeIn 300, ->
			_autoHideHandle _$message

	_autoHideHandle = ($mes) ->
		setTimeout ->
			_hideHandle $mes
		, 1000

	_hideHandle = ($mes) ->
		$mes.fadeOut 300, ->
			$mes.remove()
			$mes = null
			return
		return

	_self =
		show: _showHandle
		hide: _hideHandle

	return _self

filterChanges = ->
	$selectedMessage = $('<div class="filter-message"><div class="filter-message_label js-filter-message_label"></div><a href="#" class="filter-message_link">Показать</a></div>')
	$('main').append $selectedMessage
	_currentInterval = null

	_getCount = (cb) ->
		if _currentInterval?
			clearInterval _currentInterval
		_currentInterval = setTimeout ->
			_currentInterval = null
			cb( getRandom(10, 150) )
		, getRandom(100, 1000)

	_getMessageElement = ->
		return $selectedMessage

	_getMessageElementCount = ->
		_getMessageElement().find('.js-filter-message_label')

	_setMessage = (count = '<img src="./images/elements/filter-loading.gif" alt="">') ->
		_getMessageElementCount().html( '<span>Товаров выбрано:</span>' + '<span>' + count + '</span>' )

	_autoHide = do ->
		_timeout = null
		return ->
			if _timeout?
				clearInterval _timeout
				_timeout = null

			_timeout = setTimeout ->
				_timeout = null
				$selectedMessage.fadeOut 300
			, 5000
			return

	$('body').on 'change', '.js-filter', (e) ->
		$target = $(e.target)
		_top = $target.offset().top + ($target.outerHeight()/2)
		_left = $('.js-filter').offset().left + $('.js-filter').outerWidth()

		_setMessage()
		_$mes = _getMessageElement()
		_$mes.show()
		_top = _top - (_$mes.outerHeight()/2)
		_$mes.hide()
		.css
			'top': _top
			'left': _left
		.fadeIn 300, ->
			_getCount (count) ->
				_setMessage count
				_autoHide()

product = ->
	$('body').on 'change', '.js-product-colors_input', (e) ->
		console.log 'change'
		$('.js-product-colors_input').removeClass '__checked'
		if this.checked
			$(this).addClass '__checked'

classAction = ->
	_getAction = ($obj) ->
		if $obj.hasAttr 'data-class-add'
			return {method: 'addClass', value: $obj.attr('data-class-add')}

		if $obj.hasAttr 'data-class-remove'
			return {method: 'removeClass', value: $obj.attr('data-class-remove')}
		
		return false

	$('body').on 'click', '[data-class-target]', ->
		$this = $(this)
		$target = $( $this.attr('data-class-target') )
		console.log $target
		if $target.length < 1 then return

		action = _getAction $this
		console.log action
		if action == false then return

		$target[action.method](action.value)

		return
	return

productGallery = ->
	$('.js-product-gallery_images-list').cleanWhitespace()

	itemSelector = '.js-product-gallery_item'

	getBigImageElement = do ->
		_bigImage = null
		_self = ->
			if !_bigImage?
				_bigImage = $('.js-product-gallery_big-image')
			return _bigImage

		return _self

	getCurrentItem = ->
		return $( itemSelector + '.__current')
	getCurrentItemIndex = ->
		return getCurrentItem().index()
	getCountItems = ->
		return $( itemSelector ).length
	setCurrentItem = (arg) ->
		if typeof arg == 'number'
			return setCurrentItemIndex arg
		if typeof arg == 'string'
			arg = $(arg)
		if arg instanceof jQuery && arg.length > 0
			return setCurrentItemObject arg
		return false
	getItemFromIndex = (index) ->
		return $( itemSelector + ':eq(' + index + ')')
	clearCurrentStatus = ->
		$('.js-product-gallery_item.__current').removeClass '__current'
		return
	setCurrentStatus = ($obj) ->
		return $obj.addClass '__current'
	isCurrentItem = ($obj) ->
		return $obj.hasClass '__current'

	setCurrentItemObject = ($obj) ->
		if isCurrentItem $obj then return
		do clearCurrentStatus
		onCurrentChange setCurrentStatus $obj
		return

	setCurrentItemIndex = (index) ->
		if index < 0 then return
		if index > getCountItems() - 1 then return
		setCurrentItemObject getItemFromIndex index
		return

	getItemWidth = ->
		$tmpObj = $(itemSelector + ':first')
		width = $tmpObj.outerWidth(true)
		if getCountItems() > 1
			width = $tmpObj.offset().left
			width = $(itemSelector + ':first').next().offset().left - width
		return width

	getCountItemsPerPage = ->
		return 4

	nextClickHandle = (e) ->
		e.preventDefault()
		if $(this).hasAttr 'disabled' then return

		setCurrentItem (getCurrentItemIndex() + 1)
		return
	prevClickHandle = (e) ->
		e.preventDefault()
		if $(this).hasAttr 'disabled' then return

		setCurrentItem (getCurrentItemIndex() - 1)
		return
	itemClickHandle = (e) ->
		e.preventDefault()
		setCurrentItem $(this)
		return
	onCurrentChange = do ->
		_listeners = []
		_self = (arg) ->
			if arg?
				if typeof arg == 'function'
					_listeners.push arg
					return
				if !(arg instanceof jQuery) then return
			for eventListener in _listeners
				eventListener arg
		return _self

	checkArrowsStatus = do ->
		_self = ->
			_currentIndex = getCurrentItemIndex()
			_count = getCountItems()
			if _currentIndex == 0
				$('.js-product-gallery_prev').attr 'disabled', 'disabled'
			else
				$('.js-product-gallery_prev').removeAttr 'disabled'

			if _currentIndex == _count - 1
				$('.js-product-gallery_next').attr 'disabled', 'disabled'
			else
				$('.js-product-gallery_next').removeAttr 'disabled'
		onCurrentChange _self
		return _self

	direction = do ->
		_lastIndex = 0
		_currentDirection = -1

		_setDirection = (newIndex) ->
			if newIndex > _lastIndex
				_currentDirection = 1
			else
				_currentDirection = -1
			_lastIndex = newIndex
			return _currentDirection

		_getDirection = () ->
			return _currentDirection

		_self = (arg) ->
			if arg? && typeof arg == 'number'
				return _setDirection(arg)
			else
				return _getDirection()

		onCurrentChange ->
			_setDirection getCurrentItemIndex()

		return _self

	checkPanelPosition = do ->
		_lastPos = 0
		_self = ->
			_currentIndex = getCurrentItemIndex()
			_count = getCountItems()
			_countPerPage = getCountItemsPerPage()
			_itemWidth = getItemWidth()
			_$panel = $('.js-product-gallery_images-list')
			_left = parseFloat _$panel.css('left')
			_currentPanelIndex = _left/_itemWidth
			if _currentPanelIndex < 0 then _currentPanelIndex = -_currentPanelIndex
			_panelWidth = _count*_itemWidth
			_visibleWidth = _countPerPage*_itemWidth

			_isCurrentVisible = ->
				if _currentIndex <= _currentPanelIndex then return false
				if _currentIndex >= (_currentPanelIndex + _countPerPage) - 1 then return false
				return true

			if _isCurrentVisible() then return

			_newLeft = -(_currentIndex - ( if direction() == 1 then 2 else 1) )*_itemWidth
			if _newLeft > 0 then _newLeft = 0
			if  _visibleWidth - _panelWidth > _newLeft
				_newLeft = _visibleWidth - _panelWidth

			if _lastPos == _newLeft then return
			_lastPos = _newLeft
			_$panel.stop().animate {left: _lastPos}, 300, ->
			return


		onCurrentChange _self
		return _self

	setBigImage = do ->
		_isLoaded = false
		_loadHandle = ->
			_isLoaded = true
			$(this).parent().removeClass '__loading'
			return
		_loadFix = do ->
			_timeout = null
			_self = ($obj) ->
				if _timeout?
					clearTimeout _timeout

				_timeout = setInterval ->
					if( $obj.get(0).complete )
						clearInterval(_timeout)
						if !isLoaded
							isLoaded = true
							$obj.trigger 'load'
					return
				, 100

			return _self


		_self = (imageLink) ->
			_$bigImage = getBigImageElement()
			_$bigImage.parent().addClass '__loading'
			_$bigImage.one 'load', _loadHandle
			_loadFix _$bigImage
			_$bigImage.parent('a').attr('href', imageLink)
			return _$bigImage.attr('src', imageLink)


		onCurrentChange ($obj) ->
			if !($obj) then return
			if !( $obj instanceof jQuery && $obj.length > 0) then return
			if !$obj.hasAttr('href') then return
			_self $obj.attr 'href'
			return
		

		return _self


	$('body').on 'click', '.js-product-gallery_prev', prevClickHandle
	$('body').on 'click', '.js-product-gallery_next', nextClickHandle
	$('body').on 'click', '.js-product-gallery_item', itemClickHandle

	do checkArrowsStatus