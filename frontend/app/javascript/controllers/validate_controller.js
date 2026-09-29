import { Controller } from '@hotwired/stimulus'
import _ from 'lodash'

export default class ValidateFormController extends Controller {
  static targets = [ 'validateForm' ]

  connect() {
    console.debug('validate', 'connect')
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
