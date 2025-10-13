import React from 'react'
import { createRoot } from 'react-dom/client'

import Clock from './clock'

createRoot document.querySelector 'body'
  .render <Clock/>
