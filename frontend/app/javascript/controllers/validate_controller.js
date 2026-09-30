import { Controller } from '@hotwired/stimulus'
import _ from 'lodash'

export default class ValidateFormController extends Controller {
  static targets = [ 'validateForm' ]

  connect() {
    console.debug('validate', 'connect')
    const element = this.validateFormTarget.querySelector('[type="submit"]')
    const errorMessages = document.getElementById('errorMessages')
    if (errorMessages != null) {
      element.classList.add('disabled')
      element.setAttribute('disabled', 'disabled')
    } else {
      element.classList.remove('disabled')
      element.removeAttribute('disabled')
    }
  }

  getFormValues() {
    const formData = {}
    new FormData(this.validateFormTarget).forEach((value, key) => {
      formData[key] = value
    })
    return formData
  }

  submitForm(values) {
    this.validateFormTarget.requestSubmit()
  }

  submit(event) {
    event.preventDefault()
    event.target.classList.add('disabled')
    event.target.setAttribute('disabled', 'disabled')

    const formValues = this.getFormValues()
    this.submitForm(formValues)
  }
}
