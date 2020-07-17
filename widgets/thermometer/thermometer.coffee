class Dashing.Thermometer extends Dashing.Widget
  @accessor 'value', Dashing.AnimatedValue

  constructor: ->
    super
    @observe 'value', (value) ->
      $(@node).find(".value").val(value).trigger('change')
      widget = $(@node).find(".widget-thermometer")
      widget.context.style.setProperty("--therm-height", @getTemplateValue('height')) if @get('height')
      widget.context.style.setProperty("--therm-width", @getTemplateValue('width')) if @get('width')
      widget.context.style.setProperty("--temp-percent", @getTempPct(value) + '%')

  
  # ready: ->

  onData: (data) ->
    max = @get('max')
    min = @get('min')
    warn = @get('warningThreshold')
    crit = @get('criticalThreshold')
    oldValue = @get('value')
    newValue = data.value
    tempPct = ( (newValue - min) / (max - min) ) * 100
    t = $(@node).find(".widget-thermometer")
    t.context.style.setProperty("--temp-percent", tempPct + '%')


    if data.value.is_a?(String) || !data.value
      # console.log('null')
      #$(@node).addClass('null') 
    else if data.value > @get('critical')
      # console.log('critical')
      #$(@node).addClass('critical')    
    else if data.value > @get('warning') 
      # console.log('warning')
      #$(@node).addClass('warning') 
    else   
      # console.log('good')
      #$(@node).addClass('good') 

  getTempPct: (value) ->
    max = @get('max')
    min = @get('min')
    return ( (value - min) / (max - min) ) * 100

  getTemplateValue: (name) ->
    val = @get(name)
    return if isNaN(val) then val else val + 'px'