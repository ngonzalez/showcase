import { Controller } from '@hotwired/stimulus'
import _ from 'lodash'

export default class extends Controller {
  static targets = [ 'documentationPage']

  connect() {
    _.each(document.getElementById('documentationMenu').querySelectorAll('a.menu-link'), (element, index) => {
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
    _.each(document.getElementById('documentationMenu').querySelectorAll('a.menu-link'), (element, index) => {
      if ((document.location.hash != '') && (element.getAttribute('href') == document.location.hash)) {
        element.classList.add('active')
        let section = this.documentationPageTarget.querySelectorAll('[name="section"]')[0]
        section.innerHTML = element.getAttribute('href')

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
    const anchor = event.target.getAttribute('href')
    if (anchor) {
      _.each(document.getElementById('documentationMenu').querySelectorAll('a.menu-link'), (element, index) => {
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
}
