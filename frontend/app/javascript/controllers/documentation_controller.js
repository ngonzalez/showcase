import { Controller } from '@hotwired/stimulus'
import _ from 'lodash'

export default class extends Controller {
  static targets = [ 'documentationPage']

  connect() {
    _.each(document.getElementById('documentationMenu').querySelectorAll('li.menu-link'), (element, index) => {
      element.classList.remove('active')

      let statusElement = element.querySelectorAll('[aria-label="status"]')[0]
      if (typeof statusElement != 'undefined') {
        statusElement.style.visibility = 'hidden'
      }

      let statusAnimatedElement = element.querySelectorAll('[aria-label="status-animated"]')[0]
      if (typeof statusAnimatedElement != 'undefined') {
        statusAnimatedElement.style.visibility = 'hidden'
      }
    })
    _.each(document.getElementById('documentationMenu').querySelectorAll('li.menu-link'), (element, index) => {
      let link = element.querySelectorAll('a')[0]
      if ((document.location.hash != '') && (typeof(link) != 'undefined') && (link.getAttribute('href') == document.location.hash)) {
        element.classList.add('active')
        let section = this.documentationPageTarget.querySelectorAll('[name="section"]')[0]
        section.innerHTML = element.getElementsByTagName('a')[0].getAttribute('href')

        let statusElement = element.querySelectorAll('[aria-label="status"]')[0]
        if (typeof statusElement != 'undefined') {
          statusElement.style.visibility = 'visible'
        }

        let statusAnimatedElement = element.querySelectorAll('[aria-label="status-animated"]')[0]
        if (typeof statusAnimatedElement != 'undefined') {
          statusAnimatedElement.style.visibility = 'visible'
        }
      }
    })
  }
  
  clickSidebarMenu(event) {
    _.each(document.getElementById('documentationMenu').querySelectorAll('li.menu-link'), (element, index) => {
      element.classList.remove('active')

      let statusElement = element.querySelectorAll('[aria-label="status"]')[0]
      if (typeof statusElement != 'undefined') {
        statusElement.style.visibility = 'hidden'
      }

      let statusAnimatedElement = element.querySelectorAll('[aria-label="status-animated"]')[0]
      if (typeof statusAnimatedElement != 'undefined') {
        statusAnimatedElement.style.visibility = 'hidden'
      }
    })
    event.target.parentNode.classList.add('active')
    let sectionElement = this.documentationPageTarget.querySelectorAll('[name="section"]')[0]
    sectionElement.innerHTML = event.target.getAttribute('href')

    let statusElement = event.target.querySelectorAll('[aria-label="status"]')[0]
    if (typeof statusElement != 'undefined') {
      statusElement.style.visibility = 'visible'
    }

    let statusAnimatedElement = event.target.querySelectorAll('[aria-label="status-animated"]')[0]
    if (typeof statusAnimatedElement != 'undefined') {
      statusAnimatedElement.style.visibility = 'visible'
    }
  }
}
