class TabView extends Backbone.View

  className : "TabView"
  

  events:
    "click paper-tab"	: 'tabClicked'

  tabs:  [
        {"title": "Assessments", "weight": 1, "url":"#assessments", "views": [{className: "AssessmentsViewController"} ] },
        { "title": "Sync", "weight": 2, "url":"#bandwidth", "views": [{className: "BandwidthCheckView"}, {className: "UniversalUploadView"}, {className: "ResultsSaveAsFileView"}] },
      ]

  config: =>
                  
  # Allow for overridden configs
  initialize: (config={}) =>
    _.extend(@config(), config)
    @tabIndex = null

  myFunction: ()->
    console.log "do some work here JW"

  tabClicked: (element) ->
    tabNumber = JSON.parse($(element.currentTarget).find('a')[0].getAttribute('data-tab-to-use'))
    @setTab(tabNumber)

  setTab: (tabNumber) ->
    tab = @tabs[tabNumber]
    views = []
    tab.views.forEach (view) ->
      prototypeView = new window[view.className]
      views.push(prototypeView)
    
    if (@tabIndex == null)
      slideOut = 'right'
      slideIn = 'left'
    else if @tabIndex < tabNumber
      slideOut = 'left'
      slideIn = 'right'
    else if @tabIndex > tabNumber
      slideOut = 'right'
      slideIn = 'left'
    @tabIndex = tabNumber
    console.log('slide')
    tabBody = this.$el.find('.classHtml')[0]
    $(tabBody).hide("slide", { direction: slideOut }, 200)

    slideIt = () ->
      $(tabBody).html('')
      views.forEach (view) ->
        view.render()
        $(tabBody).append view.el
      $(tabBody).show("slide", { easing: 'swing', direction: slideIn }, 200)

    setTimeout(slideIt, 200)

  
  render: =>

    @$el.html ''
     
    @tabTitles = ''
    i = 0
    for tab in @tabs
      @tabTitles += "<paper-tab link>
                    <a id='#{tab.views[0].className}' class='link' data-tab-to-use='#{i}' tabindex='-1'>#{tab.title}</a>
                  </paper-tab>"
      i++
 
    @$el.html "
    <link rel='import' href='js/lib/bower_components/paper-tabs/paper-tab.html'>
    <link rel='import' href='js/lib/bower_components/paper-tabs/paper-tabs.html'>
    <style is='custom-style'>
      .AssessmentsView {
        background: white;
      }
      .TabView .classHtml {
        padding: 20px;
      }
      paper-tabs, paper-toolbar {
            background-color: #F6C637; 
            color: white;
      }
      .paper-tabs-0 #selectionBar.paper-tabs {
        background-color: #000 !important;
      }
      paper-tab[link] a {
        @apply(--layout-horizontal);
        @apply(--layout-center-center);
        /* color: #F6C637; */
        color: white;
        text-decoration: none;
      }
    </style>
    <div>
      <paper-tabs selected='0'>
        #{@tabTitles}
      </paper-tabs>     
    </div>
    <div class='classHtml'></div>
    "

    @setTab(0)
