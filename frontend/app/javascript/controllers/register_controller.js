import { Controller } from '@hotwired/stimulus'
import _ from 'lodash'

export default class RegisterFormController extends Controller {
  static targets = [ 'registerForm' ]

  connect() {
    console.debug('register', 'connect')
    this.user = {}
    this.selectedForm = 'person'
    this.toggleCompanyForm()
    this.validateForm()
    this.setAccountType()
    this.setUserPlan()
  }

  input(event) {
    this.setUserValues(event)
    this.validateForm()
  }

  inputChanged(event) {
    this.validateCheckBoxes(event)
    this.validateForm()
  }

  radioSelect(event) {
    this.selectRadioEvent(event)
    this.toggleCompanyForm()
    this.validateForm()
  }

  labelClicked(event) {
    this.selectRadioEvent(event)
    this.toggleCompanyForm()
    this.validateForm()
  }

  selectRadioEvent(event) {
    event.preventDefault()
    this.setSelectedForm(event)
  }

  validateForm() {
    this.valid = true
    this.validateFieldsInForm()
    this.toggleSubmitButton()
  }

  setAccountType() {
    _.each(this.registerFormTarget.querySelectorAll('[name="user[accountType]"]'), (element, index) => {
      if (element.value == this.selectedForm) {
        element.checked = true
        _.each(element.parentNode.querySelectorAll('label'), (item, i) => {
          item.style = "text-decoration:underline;"
        })
      }
    })
  }

  setSelectedForm(event) {
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

  toggleCompanyForm() {
    _.each(this.registerFormTarget.querySelectorAll('[name="user[companyName]"]'), (element, index) => {
      if (this.selectedForm == 'company') {
        element.parentNode.parentNode.style.display = 'block'
      } else {
        element.parentNode.parentNode.style.display = 'none'
      }
    })
    _.each(this.registerFormTarget.querySelectorAll('[name="user[firstName]"]'), (element, index) => {
      if (this.selectedForm == 'person') {
        element.parentNode.parentNode.style.display = 'block'
      } else {
        element.parentNode.parentNode.style.display = 'none'
      }
    })
    _.each(this.registerFormTarget.querySelectorAll('[name="user[lastName]"]'), (element, index) => {
      if (this.selectedForm == 'person') {
        element.parentNode.parentNode.style.display = 'block'
      } else {
        element.parentNode.parentNode.style.display = 'none'
      }
    })
  }

  toggleSubmitButton() {
    const element = this.registerFormTarget.querySelectorAll('[name="submitButton"]')[0]
    if (this.valid) {
      element.classList.add('btn-neutral')
      element.classList.remove('disabled')
      element.removeAttribute('disabled')
    } else {
      element.classList.remove('btn-neutral')
      element.classList.add('disabled')
      element.setAttribute('disabled', 'disabled')
    }
  }

  setUserValues(event) {
    if (this.selectedForm == 'company') {
      _.each(['companyName', 'emailAddress', 'address', 'postalCode', 'city', 'country', 'password', 'passwordConfirmation'], (attribute, index) => {
        if (event.target.name == "user[" + attribute + "]") {
          this.user[attribute] = event.target.value
        }
      })
    } else {
      _.each(['firstName', 'lastName', 'emailAddress', 'address', 'postalCode', 'city', 'country', 'password', 'passwordConfirmation'], (attribute, index) => {
        if (event.target.name == "user[" + attribute + "]") {
          this.user[attribute] = event.target.value
        }
      })
    }
  }

  setUserPlan() {
    _.each(['plan'], (attribute, index) => {
      if (this.registerFormTarget.querySelectorAll('[name="user[' + attribute + ']"]').length > 0) {
        this.user[attribute] = this.registerFormTarget.querySelectorAll('[name="user[' + attribute + ']"]')[0].value
      }
    })
  }

  validateFieldsInForm() {
    if (this.selectedForm == 'company') {
      _.each(['companyName', 'emailAddress', 'address', 'postalCode', 'city', 'country', 'password', 'passwordConfirmation', 'agreeToTermsAndConditions'], (attribute, index) => {
        if (typeof this.user[attribute] == "undefined" || this.user[attribute] == false) {
          this.valid = false
        }
      })
    } else {
      _.each(['firstName', 'lastName', 'emailAddress', 'address', 'postalCode', 'city', 'country', 'password', 'passwordConfirmation', 'agreeToTermsAndConditions'], (attribute, index) => {
        if (typeof this.user[attribute] == "undefined" || this.user[attribute] == false) {
          this.valid = false
        }
      })
    }
  }

  validateCheckBoxes(event) {
    _.each(['agreeToTermsAndConditions'], (attribute, index) => {
      if (event.target.name == "user[" + attribute + "]") {
        this.user[attribute] = event.target.checked
      }
    })
  }

  removeUnusedFieldsInForm() {
    if (this.selectedForm == 'company') {
      _.each(['firstName', 'lastName'], (attribute, index) => {
        _.each(this.registerFormTarget.querySelectorAll('[name="user[' + attribute + ']"]'), (element, i) => {
          element.parentNode.remove()
        })
      })
    } else {
      _.each(['companyName'], (attribute, index) => {
        _.each(this.registerFormTarget.querySelectorAll('[name="user[' + attribute + ']"]'), (element, i) => {
          element.parentNode.remove()
        })
      })
    }
  }

  submit(event) {
    event.preventDefault()
    event.target.classList.add('disabled')
    event.target.setAttribute('disabled', 'disabled')
    if (this.valid) {
      this.removeUnusedFieldsInForm()
      this.registerFormTarget.requestSubmit()
    }
  }
}

