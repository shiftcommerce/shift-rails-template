import React from "react"
import { mount } from "enzyme"

import WelcomePage from "../../../app/assets/javascripts/pages/WelcomePage"

test("renders the welcome page text", () => {
  // arrange

  // act
  const wrapper = mount(
    <WelcomePage />
  )

  // assert
  expect(wrapper).toIncludeText("Welcome To Shift Commerce Front End")
})