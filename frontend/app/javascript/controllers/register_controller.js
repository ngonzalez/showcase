import { Controller } from '@hotwired/stimulus'
import _ from 'lodash'

export default class extends Controller {
  static targets = [ 'registerForm' ]

  connect() {
    this.user = {}
    this.selectedForm = ''
    _.each(['plan'], (attribute, index) => {
      if (this.registerFormTarget.querySelectorAll('[name="user[' + attribute + ']"]').length > 0) {
        this.user[attribute] = this.registerFormTarget.querySelectorAll('[name="user[' + attribute + ']"]')[0].value
      }
    })
  }

  input(event) {
    _.each(['firstName', 'lastName', 'emailAddress', 'address', 'postalCode', 'city', 'country', 'password', 'passwordConfirmation'], (attribute, index) => {
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

  radioSelect(event) {
    this.selectRadioEvent(event)
    console.log(this.selectedForm)
  }

  labelClicked(event) {
    this.selectRadioEvent(event)
    console.log(this.selectedForm)
  }

  selectRadioEvent(event) {
    event.preventDefault()
    _.each(this.registerFormTarget.querySelectorAll('[name="user[accountType]"]'), (element, index) => {
      element.checked = false
      _.each(element.parentNode.querySelectorAll('label'), (item, i) => {
        item.style = "text-decoration:none;"
      })
    })
    _.each(event.target.parentNode.querySelectorAll('[name="user[accountType]"]'), (element, index) => {
      element.checked = true
      this.selectedForm = element.value
      _.each(event.target.parentNode.querySelectorAll('label'), (item, i) => {
        item.style = "text-decoration:underline;"
      })
    })
  }

  validateForm() {
    this.valid = true
    _.each(['firstName', 'lastName', 'emailAddress', 'address', 'postalCode', 'city', 'country', 'password', 'passwordConfirmation', 'agreeToTermsAndConditions'], (attribute, index) => {
      if (typeof this.user[attribute] == "undefined" || this.user[attribute] == false) {
        this.valid = false
      }
    })
    const submitBtn = this.registerFormTarget.querySelectorAll('[name="submitButton"]')[0]
    if (this.valid) {
      submitBtn.classList.add('btn-neutral')
    } else {
      submitBtn.classList.remove('btn-neutral')
    }
  }

  submit(event) {
    event.preventDefault()
    if (this.valid) {
      console.log(this.user)
    }
  }
}
