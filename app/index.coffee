path = require 'path'
yeoman = require 'yeoman-generator'
yosay = require 'yosay'
async = require 'async'

GulpfileGenerator = yeoman.generators.Base.extend(
  init: ->
    @on 'end', ->
      context = this

      async.series [
        (next) ->
          if context.packages.length
            context.npmInstall context.packages, save: true, -> next()
          else
            next()

        (next) ->
          if context.devPackages.length
            context.npmInstall context.devPackages, saveDev: true, -> next()
          else
            next()
      ],
      ->
        context.runInstall('npm', '')

  askFor: ->
    done = @async()
    @log yosay('Welcome to the gulpfile generator!')
    @prompt [
      {
        name: 'author'
        message: 'What\'s your name?'
      }
      {
        name: 'pkgName'
        message: 'What\'s the name of your project?'
        default: this.appname
      }
      {
        name: 'coffee'
        message: 'Do you like coffee?'
        type: 'confirm'
      }
      {
        name: 'packages'
        message: 'Should I install some npm packages for you?'
      }
      {
        name: 'devPackages'
        message: 'Need devDependencies?'
      }
    ], ((props) ->
      @author = props.author
      @pkgName = props.pkgName
      @coffee = props.coffee
      @packages = props.packages.split /[\s,]+/
      @devPackages = props.devPackages.split /[\s,]+/

      done()
    ).bind(this)

  projectfiles: ->
    @copy '_editorconfig', '.editorconfig'
    @template '_package.json', 'package.json'
    @template '_README.md', 'README.md'
    @template '_index.js', 'index.js'

    if this.coffee
      @copy 'coffee/_gulpfile.coffee', 'gulpfile.coffee'
      @copy 'coffee/_gulpfile.js', 'gulpfile.js'
      @copy 'coffee/coffeelint.json', 'coffeelint.json'
      @copy 'coffee/_index.coffee', 'index.coffee'
    else
      @copy 'javascript/_gulpfile.js', 'gulpfile.js'
      @copy 'javascript/_jshintrc', '.jshintrc'

  gitfiles: ->
    @copy '_gitattributes', '.gitattributes'
    @copy '_gitignore', '.gitignore'
)

module.exports = GulpfileGenerator
