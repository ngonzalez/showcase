import { Controller } from '@hotwired/stimulus'
import _ from 'lodash'

export default class extends Controller {
  static targets = [ 'documentationPage']

  connect() {
    _.each(document.getElementById('documentationMenu').querySelectorAll('li.menu-link'), (element, index) => {
      let link = element.querySelectorAll('a')[0]
      if ((document.location.hash != '') && (typeof(link) != 'undefined') && (link.getAttribute('href') == document.location.hash)) {
        element.classList.add('active')
        let section = this.documentationPageTarget.querySelectorAll('[name="section"]')[0]
        section.innerHTML = element.getElementsByTagName('a')[0].getAttribute('href')
      }
    })
  }
  
  clickSidebarMenu(event) {
    _.each(document.getElementById('documentationMenu').querySelectorAll('li.menu-link'), (element, index) => {
      element.classList.remove('active')
    })
    event.target.parentNode.classList.add('active')
    let section = this.documentationPageTarget.querySelectorAll('[name="section"]')[0]
    section.innerHTML = event.target.getAttribute('href')
  }
}
