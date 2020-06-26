class Dashing.List extends Dashing.Widget
  @accessor 'labelClass', ->
    'label ' + if @get('align') == 'center' then 'right' else 'left'
      
  @accessor 'valueClass', ->
    'value ' + if @get('align') == 'center' then 'left' else 'right'
  
  ready: ->
    if @get('unordered')
      $(@node).find('ol').remove()
    else
      $(@node).find('ul').remove()
    