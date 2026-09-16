import { Controller } from '@hotwired/stimulus'
import _ from 'lodash'

export default class extends Controller {
  static targets = [ 'registerForm' ]

  connect() {
    this.user = {}
    _.each(['plan'], (attribute, index) => {
      if (this.registerFormTarget.querySelectorAll('[name="user[' + attribute + ']"]').length > 0) {
        this.user[attribute] = this.registerFormTarget.querySelectorAll('[name="user[' + attribute + ']"]')[0].value
      }
    })
  }

  input(event) {
    _.each(['firstName', 'lastName', 'emailAddress', 'address', 'country', 'password', 'passwordConfirmation'], (attribute, index) => {
      if (event.target.name == "user[" + attribute + "]") {
        this.user[attribute] = event.target.value
      }
    })
    this.validateForm()
  }

  inputChanged(event) {
    _.each(['agreeToTermsAndConditions'], (attribute, index) => {
      if (event.target.name == "user[" + attribute + "]") {
        this.user[attribute] = event.target.checked
      }
    })
    this.validateForm()
  }

  validateForm() {
    this.valid = true
    _.each(['firstName', 'lastName', 'emailAddress', 'address', 'country', 'password', 'passwordConfirmation', 'agreeToTermsAndConditions'], (attribute, index) => {
      if (typeof this.user[attribute] == "undefined" || this.user[attribute] == false) {
        this.valid = false
      }
    })
    if (this.valid) {
      this.registerFormTarget.querySelectorAll('[name="submitButton"]')[0].classList.add('btn-neutral')
    } else {
      this.registerFormTarget.querySelectorAll('[name="submitButton"]')[0].classList.remove('btn-neutral')
    }
  }

  submit(event) {
    event.preventDefault()
    if (this.valid) {
      console.log(this.user)
    }
  }
}
