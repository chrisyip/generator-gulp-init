<% if (coffee) { %>require('coffee-script/register')
require('./index.coffee')
<% } else { %>module.exports = function () {
  return '<%= pkgName %> awesome!'
}
<% } %>
