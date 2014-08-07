gulp = require 'gulp'
coffeelint = require 'coffeelint'

gulp.task 'lint', ->
  gulp.src(['**/*.coffee', '!node_modules{,/**}']).pipe(coffeelint()).pipe(coffeelint.reporter())

gulp.task 'default', ['lint']
