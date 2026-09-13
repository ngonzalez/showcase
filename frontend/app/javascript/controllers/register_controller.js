import { Controller } from "@hotwired/stimulus"
import _ from "lodash"

export default class extends Controller {
  static targets = [ "registerForm" ]

  connect() {
    this.user = {}
    _.each(['plan'], (attribute, index) => {
      if (this.registerFormTarget.querySelectorAll('[name="user[' + attribute + ']"]').length > 0) {
        this.user[attribute] = this.registerFormTarget.querySelectorAll('[name="user[' + attribute + ']"]')[0].value
      }
    })
  }

  input(event) {
    _.each(['firstName', 'lastName', 'emailAddress', 'address', 'country'], (attribute, index) => {
      if (event.target.name == "user[" + attribute + "]") {
        this.user[attribute] = event.target.value
      }
    })
  }

  submit(event) {
    event.preventDefault()
    console.log(this.user)
  }

  inputChanged(event) {
    _.each(['agreeToTermsAndConditions'], (attribute, index) => {
      if (event.target.name == "user[" + attribute + "]") {
        this.user[attribute] = event.target.checked
      }
    })
  }
}
