import React from 'react'
import { render } from 'react-dom'

// routing
import { BrowserRouter as Router, Route, NavLink, Redirect, Switch } from 'react-router-dom'

// redux
import { Provider } from 'react-redux'
import configureStore from './configureStore'

// import pages
import WelcomePage from './pages/WelcomePage'

const store = configureStore()

// import css
import '../stylesheets/application.css.scss'

render(
  <Provider store={store}>
    <Router>
      <div>
        <Switch>
          <Route exact path='/' component={WelcomePage} />
        </Switch>
      </div>
    </Router>
  </Provider>,
  document.getElementById('app')
)
