import { Controller } from '@hotwired/stimulus'
import _ from 'lodash'

export default class extends Controller {
  static targets = [ 'registerForm' ]

  connect() {
    this.user = {}
    this.selectedForm = 'person'
    this.toggleCompanyForm()
    _.each(this.registerFormTarget.querySelectorAll('[name="user[accountType]"]'), (element, index) => {
      if (element.value == this.selectedForm) {
        element.checked = true
        _.each(element.parentNode.querySelectorAll('label'), (item, i) => {
          item.style = "text-decoration:underline;"
        })
      }
    })

    _.each(['plan'], (attribute, index) => {
      if (this.registerFormTarget.querySelectorAll('[name="user[' + attribute + ']"]').length > 0) {
        this.user[attribute] = this.registerFormTarget.querySelectorAll('[name="user[' + attribute + ']"]')[0].value
      }
    })
  }

  input(event) {
    _.each(this.registerFormTarget.querySelectorAll('[name="user[companyName]"]'), (element, index) => {
      if (this.selectedForm == 'company') {
        console.debug('company', this.user)
        _.each(['companyName', 'emailAddress', 'address', 'postalCode', 'city', 'country', 'password', 'passwordConfirmation'], (attribute, index) => {
          if (event.target.name == "user[" + attribute + "]") {
            this.user[attribute] = event.target.value
          }
        })
      } else {
        console.debug('person', this.user)
        _.each(['firstName', 'lastName', 'emailAddress', 'address', 'postalCode', 'city', 'country', 'password', 'passwordConfirmation'], (attribute, index) => {
          if (event.target.name == "user[" + attribute + "]") {
            this.user[attribute] = event.target.value
          }
        })
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

  validateForm() {
    this.valid = true
    _.each(this.registerFormTarget.querySelectorAll('[name="user[companyName]"]'), (element, index) => {
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
    })

    const submitBtn = this.registerFormTarget.querySelectorAll('[name="submitButton"]')[0]
    this.valid ? submitBtn.classList.add('btn-neutral') : submitBtn.classList.remove('btn-neutral')
  }

  submit(event) {
    event.preventDefault()
    if (this.valid) {
      console.log(this.user)
    }
  }
}
