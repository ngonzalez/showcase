import { Controller } from '@hotwired/stimulus'
import _ from 'lodash'

export default class ValidateFormController extends Controller {
  static targets = [ 'validateForm' ]

  connect() {
    console.debug('validate', 'connect')
  }
  submit(event) {
    // axios
    //   .post(window.BACKEND_URL, {
    //     parameters: btoa(JSON.stringify(this.user)),
    //     headers: {
    //       "Content-Type": "application/json"
    //     },
    //   })
    //   .then((response) => {
    //     console.debug(response)
    //   .catch((error) => {
    //     console.error(error)  }
    //   .finally(() => {
    //     location.href = "/complete"
    //   });
  }
}
