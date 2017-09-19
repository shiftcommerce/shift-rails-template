import { combineReducers } from 'redux'
import reduceReducers from 'reduce-reducers'

import setApiConfig from "shift-admin-ui-kit/src/javascripts/reducers/setApiConfig"
import setAuthenticationDetails from "shift-admin-ui-kit/src/javascripts/reducers/setAuthenticationDetails"

const rootReducer = combineReducers({
  api: setApiConfig,
  authentication: setAuthenticationDetails
})

export default rootReducer
