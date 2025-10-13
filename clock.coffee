import React from 'react'
import './styles'

# get the previous midnight as a reference point, once per load
midnight = new Date
midnight.setHours 0, 0, 0, 0

time = ->
  now = new Date
  hours:    now.getHours() % 12
  minutes:  now.getMinutes()
  seconds:  now.getSeconds()
  elapsed:  Math.floor (now.getTime() - midnight.getTime()) / 1000

export default \
class Clock extends React.Component
  constructor: ->
    super arguments...
    @state = { time()..., show: false }
    # fade in
    setTimeout @setState.bind(@, show: true), 1000

  updateTime: =>
    @setState time()

  blankScreen: =>
    @setState show: false

  componentDidMount: =>
    @interval = setInterval @updateTime, 1000

    # turn off after X minutes: ?sleep=10
    # good for OLED displays when used as a screensaver
    if sleep = parseInt new URLSearchParams(location.search).get 'sleep'
      @timeout = setTimeout @blankScreen, sleep * 60 * 1000

  componentWillUnmount: =>
    clearInterval @interval
    clearTimeout @timeout

  render: ->
    <div
      className='Clock'
      style={opacity: @state.show + 0}
    >
      <Digital {@state...}/>
      <Analog {@state...} />
    </div>

class Digital extends React.Component
  render: ->
    { hours, minutes, seconds } = @props
    <div className="Digital">
      <span className="time">
        <span className="hours">{hours}</span>
        <span className="colon" style={opacity: Math.min 1, 0.66 + seconds % 2}>:</span>
        <span className="minutes">{"#{minutes}".padStart 2, '0'}</span>
      </span>
    </div>



class Analog extends React.Component
  render: ->
    { elapsed } = @props

    <div className="Analog" style={zoom: 1}>
      <div
        className="hour"
        style={transform: "rotate(#{360 / 12 * elapsed / 60 / 60}deg)"}
      />
      <div
        className="minute"
        style={transform: "rotate(#{360 / 60 * elapsed / 60}deg)"}
      />
      <div
        className="second"
        style={transform: "rotate(#{(360 / 60) * elapsed}deg)"}
      />
    </div>
