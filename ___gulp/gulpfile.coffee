gulp = require 'gulp'
jade = require 'gulp-jade'
stylus = require 'gulp-stylus'
concat = require 'gulp-concat'
rename = require 'gulp-rename'
autoprefixer = require 'gulp-autoprefixer'
coffee = require 'gulp-coffee'
uglify = require 'gulp-uglify'

#connect = require 'gulp-connect'
browserSync  = require 'browser-sync'
reload = browserSync.reload

minifyCSS = require 'gulp-minify-css'
tap = require 'gulp-tap'
ncp = require('ncp').ncp

fs = require 'fs'
path =  require 'path'

if !fs.existsSync '../web/'
	fs.mkdirSync '../web/'


getDesc = (txt) ->
	dict = fs.readFileSync './dictionary.json', 'utf-8'
	dict = JSON.parse dict
	for key, value of dict
		if key == txt
			return value
	return txt

showErr = (err) ->
	console.log "\n\n======================================================\n\n  #{err}\n\n======================================================\n\n"
	this.emit 'end'

deleteFolderRecursive = (path) ->
	files = []
	if fs.existsSync path
		console.log '\n==== ' + path + ' REMOVING...\n'
		files = fs.readdirSync path, (er) ->
			console.log er
		files.forEach (file,index)->
			curPath = path + "/" + file;
			if fs.lstatSync(curPath).isDirectory()
				deleteFolderRecursive curPath
			else 
				fs.unlinkSync curPath, (er) ->
					console.log er
		fs.rmdirSync path, (er) ->
			console.log er
	else
		console.log '\n==== ' + path + ' NOT EXISTS\n'


ncp.limit = 30

source = '../__dev/_index/'
destination = '../web/_index/'

console.log 'Копирование ' + source + ' в ' + destination + '...'

ncp source, destination, {
		clobber: false
		filter: '.jade'
	}, (err) ->
	if err
		return console.error err
	console.log 'Копирование ' + source + ' в ' + destination + ' завершено!'

gulp.task 'browser-sync', ->
  browserSync server: baseDir: '../web'



gulp.task 'jade', ->
  gulp.src '../__dev/views/*.jade'

  .pipe jade({pretty: true })
  .on 'error', showErr
  .pipe gulp.dest '../web/'
  .on 'end', ->
    do reload

  gulp.start 'index'

gulp.task 'index', ->
	dirs = fs.readdirSync '../web/'
	files = []
	for file in dirs
		if( file.indexOf('.html') + 1 && !( file.indexOf('index') + 1 ) )
			files.push { file: (file.replace '.html', ''), name: getDesc(file)}

	gulp.src '../__dev/_index/index.jade'
		.pipe jade({pretty: true, locals: {'pages': files}})
			.on 'error', showErr
		.pipe gulp.dest '../web/'

gulp.task 'gen-css', ->
	gulp.src [
		'../__dev/styles/stylus/*.styl'
	]
		.pipe concat '00_production.styl'
		.pipe gulp.dest '../__dev/styles/__tmp/'
		.pipe do stylus
			.on 'error', showErr
		.pipe autoprefixer({browsers: ['last 20 version']})
			.on 'error', showErr
		.pipe rename 'production.css'
		.pipe gulp.dest '../web/css/'
    .pipe reload {stream:true}

gulp.task 'concat-vendors-css', ->
	gulp.src [
		'../__dev/styles/vendors/*.css'
	]
	.pipe concat 'vendors.css'
	.pipe autoprefixer({browsers: ['last 20 version']})
	.on 'error', showErr
	.pipe minifyCSS({keepSpecialComments: 0})
	.on 'error', showErr
	.pipe gulp.dest '../web/css/'
	.pipe reload {stream:true}

gulp.task 'buld-coffee', ->
	gulp.src [
		'../__dev/scripts/coffee/*.coffee'
	]
		.pipe do coffee
			.on 'error', showErr
		.pipe concat 'production.js'
			.on 'error', showErr
		.pipe gulp.dest '../web/scripts/'
    .on 'end', ->
      do reload


gulp.task 'copy-base-js', ->

  scripts_in = '../__dev/scripts/base'
  scripts_out = '../web/scripts'

  deleteFolderRecursive scripts_out

  console.log 'Копирование ' + scripts_in + ' в ' + scripts_out + '...'

  ncp scripts_in, scripts_out, {
      clobber: false

    }, (err) ->
    if err
      return console.error err
    console.log 'Копирование ' + scripts_in + ' в ' + scripts_out + ' завершено!'

gulp.task 'watch', ->
  gulp.watch [
    '../__dev/views/*.jade',
    '../__dev/views/**/*.jade'
  ], ['jade']
  gulp.watch [
    '../__dev/styles/stylus/*.styl',
    '!../__dev/styles/stylus/00_production.styl'
  ], ['gen-css']

  gulp.watch [
    '../__dev/scripts/coffee/*.coffee',
  ], ['buld-coffee']
  gulp.watch [
    '../__dev/styles/vendors/*.css'
  ], ['concat-vendors-css']


  gulp.watch ['dictionary.json'], ['index']
gulp.task 'default', ['copy-base-js', 'jade', 'gen-css', 'buld-coffee', 'watch', 'browser-sync', 'concat-vendors-css']
