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

    const formData = {}
    new FormData(this.validateFormTarget).forEach((value, key) => {
      formData[key] = value
    })

    axios
      .post(window.BACKEND_URL, {
        parameters: btoa(JSON.stringify(formData)),
        headers: {
          "Content-Type": "application/json"
        },
      })
      .then((response) => {
        console.debug(response)
      })
      .catch((error) => {
        console.error(error)
      })
      .finally(() => {
        document.location.href = "/confirmation"
      })
  }
}
