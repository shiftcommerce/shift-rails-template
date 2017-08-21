import React from 'react'
import { render } from 'react-dom'

// routing
import { BrowserRouter as Router, Route, NavLink, Redirect, Switch } from 'react-router-dom'

// redux
import { Provider } from 'react-redux'
import configureStore from './configureStore'

// import components
import { AppShell, ApiConfig } from 'shift-admin-ui-kit'

// import pages
import WelcomePage from './pages/WelcomePage'

// import css
import '../stylesheets/application.css.scss'

const store = configureStore()

let baseEndpoint = window.location.origin
if (DEVELOPMENT) {
  baseEndpoint = API_HOST
}
baseEndpoint += '/<%= app_name.gsub(/^shift-/,'') %>/v1'

render(
  <Provider store={store}>
    <Router>
      <Switch>
        <AppShell activeSection="PIM" >
          <ApiConfig baseEndpoint={ baseEndpoint }/>
          <Route exact path='/' component={ WelcomePage } />
        </AppShell>
      </Switch>
    </Router>
  </Provider>,
  document.getElementById('app')
)
