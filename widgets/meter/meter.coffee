class Dashing.Meter extends Dashing.Widget

  @accessor 'value', Dashing.AnimatedValue

  constructor: ->
    super
    @observe 'value', (value) ->
      $(@node).find(".meter").val(value).trigger('change')

  ready: ->
    meter = $(@node).find(".meter")
    meter.attr("data-bgcolor", meter.css("background-color"))
    meter.attr("data-fgcolor", meter.css("color"))
    meter.knob()
    @onData(this)

  onData: (data) ->
    data.updateAt = new Date()
    $(@node).removeClass('good')
    $(@node).removeClass('warning')    
    $(@node).removeClass('critical')    
    $(@node).removeClass('null') 

    if data.value.is_a?(String)
      $(@node).addClass('null') 
    else if data.value > @get('critical')
      $(@node).addClass('critical')    
    else if data.value > @get('warning') 
      $(@node).addClass('warning') 
    else   
      $(@node).addClass('good') 

