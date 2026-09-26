import { Controller } from '@hotwired/stimulus'
import _ from 'lodash'

export default class ValidateFormController extends Controller {
  static targets = [ 'validateForm' ]

  connect() {
    console.debug('validate', 'connect')

    const values = this.getFormValues()

    this.valid = true

    axios
      .post(window.verifyEmailAddress, {
        parameters: btoa(JSON.stringify(values)),
        headers: {
          "Content-Type": "application/json"
        },
      })
      .then((response) => {
        if (response.data['verify_account'] || response.data['verify_user']) {
          var container = document.getElementById('errorMessages')
          var element = document.createElement('ul')
          container.parentNode.parentNode.style.display = 'block'
          container.append(element)
          if (response.data['verify_account'] != []) {
            _.each(response.data['verify_account'], (item, i) => {
              var li = document.createElement('li')
              li.innerHTML = item
              element.append(li)
              this.valid = false
            })
          }
          if (response.data['verify_user'] != []) {
            _.each(response.data['verify_user'], (item, i) => {
              var li = document.createElement('li')
              li.innerHTML = item
              element.append(li)
              this.valid = false
            })
          }
        } else {
          var container = document.getElementById('errorMessages')
          container.parentNode.parentNode.style.display = 'none'
        }
      })
      .finally(() => {
        const element = this.validateFormTarget.querySelectorAll('[type="submit"]')[0]
        if (this.valid) {
          element.classList.remove('disabled')
          element.removeAttribute('disabled')
        } else {
          element.classList.add('disabled')
          element.setAttribute('disabled', 'disabled')
        }
      })
  }

  getFormValues() {
    const formData = {}
    new FormData(this.validateFormTarget).forEach((value, key) => {
      formData[key] = value
    })
    return formData
  }

  submitForm(values) {
    axios
      .post(window.webRegistrationUrl, {
        parameters: btoa(JSON.stringify(values)),
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

  submit(event) {
    event.preventDefault()
    event.target.classList.add('disabled')
    event.target.setAttribute('disabled', 'disabled')

    const formValues = this.getFormValues()
    this.submitForm(formValues)
  }
}
