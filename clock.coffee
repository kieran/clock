import React from 'react'
import './styles'

# get the initial config, and a handle for updating the URL
url = new URL location.href

# destructure the params
{
  sleep
  digital
  analog
} = Object.fromEntries url.searchParams

defaults =
  digital: 10
  analog: 100

# get the previous midnight as a reference point, once per load
midnight = new Date
midnight.setHours 0, 0, 0, 0

# get the current time
time = ->
  now = new Date
  document.title = now.toLocaleTimeString()

  hours:    now.getHours() % 12
  minutes:  now.getMinutes()
  seconds:  now.getSeconds()
  elapsed:  Math.floor (now.getTime() - midnight.getTime()) / 1000

export default \
class Clock extends React.Component
  constructor: ->
    super arguments...
    @state = {
      time()...
      show: false
      digital: parseInt digital or defaults.digital
      analog: parseInt analog or defaults.analog
    }
    # fade in
    setTimeout @setState.bind(@, show: true), 1000

  persistState: =>
    url.searchParams.delete 'digital'
    url.searchParams.delete 'analog'
    url.searchParams.set 'digital', @state.digital unless @state.digital is defaults.digital
    url.searchParams.set 'analog', @state.analog unless @state.analog is defaults.analog
    history.replaceState {}, null, url.href

  handleKeyDown: (e)=>
    if e.metaKey
      switch e.key
        when 'ArrowUp'
          @setState digital: Math.min 100, @state.digital + 1
          setTimeout @persistState, 0
        when 'ArrowDown'
          @setState digital: Math.max 0, @state.digital - 1
          setTimeout @persistState, 0

  updateTime: =>
    @setState time()

  blankScreen: =>
    @setState show: false

  componentDidMount: =>
    document.addEventListener 'keydown', @handleKeyDown

    @interval = setInterval @updateTime, 1000

    # turn off after X minutes: ?sleep=10
    # good for OLED displays when used as a screensaver
    @timeout = setTimeout @blankScreen, 60 * 1000 * parseInt sleep if sleep

  componentWillUnmount: =>
    document.removeEventListener 'keydown', @handleKeyDown
    clearInterval @interval
    clearTimeout @timeout

  render: ->
    <div
      className='Clock'
      style={opacity: @state.show + 0}
    >
      <Digital {@state...} style={opacity: 0.01 * @state.digital} />
      <Analog {@state...} style={opacity: 0.01 * @state.analog} />
    </div>

Digital = ({ hours, minutes, seconds, style })->
  <div className="Digital" style={style}>
    <span className="time">
      <span className="hours">{hours}</span>
      <span className="colon" style={opacity: Math.min 1, 0.66 + seconds % 2}>:</span>
      <span className="minutes">{"#{minutes}".padStart 2, '0'}</span>
    </span>
  </div>

Analog = ({ elapsed, style })->
  <div className="Analog" style={style}>
    <div
      className="hour"
      style={transform: "rotate(#{Math.floor 360 / 12 * elapsed / 60 / 60}deg)"}
    />
    <div
      className="minute"
      style={transform: "rotate(#{Math.floor 360 / 60 * elapsed / 60}deg)"}
    />
    <div
      className="second"
      style={transform: "rotate(#{(360 / 60) * elapsed}deg)"}
    />
  </div>
