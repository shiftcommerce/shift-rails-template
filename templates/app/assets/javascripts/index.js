import React from 'react'
import { render } from 'react-dom'

// routing
import { BrowserRouter as Router, Route, NavLink, Redirect, Switch } from 'react-router-dom'

// redux
import { Provider } from 'react-redux'
import { setEndpointHost, setEndpointPath, setAccessToken, setHeaders } from 'redux-json-api'
import rootReducer from './rootReducer'
import configureStore from './configureStore'

// import pages
import WelcomePage from './pages/WelcomePage'

const store = configureStore()

if (DEVELOPMENT) {
  store.dispatch(setEndpointHost(API_HOST))
} else {
  store.dispatch(setEndpointHost(window.location.origin))
}
store.dispatch(setEndpointPath('/inventory/v1'))

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
