import { Controller } from '@hotwired/stimulus'
import _ from 'lodash'

export default class ValidateFormController extends Controller {
  static targets = [ 'validateForm' ]

  connect() {
    console.debug('validate', 'connect')
  }
  submit(event) {
    event.preventDefault()
    event.target.classList.add('disabled')
    event.target.setAttribute('disabled', 'disabled')
    this.validateFormTarget.requestSubmit()
  }
}
