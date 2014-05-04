# DOM Sourced Table
# =================
# * You can create a datatable component from a table that already exists in the DOM
###
```html
{{#dataTable selector="dom-source-datatable" domSource=true debug="all" }}
    {{> domSource }}
{{/dataTable}}
```
###
Template.domSource.routes = -> Router.collection.find()

# Array Data Source
# =================
# * You can render static ( or client only ) data easily by setting the `rows` property to an array of objects
###
```html
{{> dataTable
    selector=pages.selector
    columns=pages.columns
    rows=pages.rows
}}
```
###
Template.datasources.pages = ->
  pages =
    # ## Columns
    #   * `data` maps the object properties to column headings
    #   * `title` is the column heading
    #   * `mRender` is a custom render function for that property ( default is "" )
    columns: [
      {
        title: "Route"
        data: "route"
      }
      {
        title: "Path"
        data: "path"
      }
      {
        title: "Controller"
        data: "controller"
        mRender:  ( data, type, row ) ->
          row.controller ?= "null"
      }
      {
        title: "Title"
        data: "page.title"
        mRender:  ( data, type, row ) ->
          row.page.title ?= ""
      }
      {
        title: "Subtitile"
        data: "page.subtitle"
        mRender:  ( data, type, row ) ->
          row.page.subtitle ?= ""
      }
      {
        title: "External Route"
        data: "external"
        mRender: ( data, type, row ) ->
          row.external ?= "false"
      }
    ]
  # ## Selector
  #   * must be unique in page scope
    selector: "dataTable-pages"
  # ## Rows
  #   * Array data source for this table
    rows: Router.collection.find().fetch()
  return pages

# Reactive Data Source
# ====================
# * You must setup a Datatables publication on the server.
# * See `server/publications.coffee` for example publications.
Template.datasources.browsers = ->
  browsers =
    columns: [
      {
        title: "Engine"
        data: "engine"
      }
      {
        title: "Browser"
        data: "browser"
      }
      {
        title: "Platform"
        data: "platform"
      }
      {
        title: "Version"
        data: "version"
        sClass: "center"
      }
      {
        title: "Grade"
        data: "grade"
        sClass: "center"
        mRender: ( data, type, row ) ->
          row ?= ""
          switch row.grade
            when "A" then return "<b>A</b>"
            else return row.grade
      }
      {
        title: "Created"
        data: "createdAt"
        mRender: ( data, type, row ) ->
          row.createdAt ?= ""
          if row.createdAt
            return moment( row.createdAt ).fromNow()
          else return row.createdAt
      }
      {
        title: "Counter"
        data: "counter"
      }
    ]
    selector: "dataTable-browsers"
    # ## Collection
    #   * the collection these documents come from, must be the same as the server collection
    collection: Browsers
    # ## Subscription
    #   * the datatables publication providing the data on the server
    subscription: "a_browsers"
    # ## Query
    #   * the initial filter on the dataset
    query:
      grade: "A"
  return browsers