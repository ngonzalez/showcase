import { Controller } from '@hotwired/stimulus'
import _ from 'lodash'

export default class extends Controller {
  static targets = [ 'documentationPage']

  connect() {
    _.each(document.getElementById('documentationMenu').getElementsByTagName('li'), (element, index) => {
      if (index == 0) {
        element.classList.add('active')
        this.documentationPageTarget.querySelectorAll('[name="section"]')[0].innerHTML = element.getElementsByTagName('a')[0].getAttribute('href')
      }
    })
  }
  
  clickSidebarMenu(event) {
    _.each(document.getElementById('documentationMenu').getElementsByTagName('li'), (element, index) => {
      element.classList.remove('active')
    })
    event.target.parentNode.classList.add('active')
    this.documentationPageTarget.querySelectorAll('[name="section"]')[0].innerHTML = event.target.getAttribute('href')
  }
}
