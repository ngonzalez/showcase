import { Controller } from '@hotwired/stimulus'
import { marked } from 'marked';
import _ from 'lodash'

export default class extends Controller {
  static targets = [ 'documentationPage']

  connect() {
    var documentation = {
      "#documentation-index": "https://link12.ddns.net:4040/attachment/3?type=TextFile",
      "#desktop-application": "https://link12.ddns.net:4040/attachment/1?type=TextFile"
    }
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
        let container = this.documentationPageTarget.querySelectorAll('[name="container"]')[0]
        let anchor = element.getAttribute('href')
        if (documentation[anchor]) {
          axios
            .get(documentation[anchor], {
              headers: {
                "Content-Type": "application/json"
              },
            })
            .then((response) => {
              container.innerHTML = marked.parse(response.data)
              _.each(document.getElementsByTagName('pre'), (item, i) => {
                let div = document.createElement('div')
                div.classList.add('mockup-code')
                div.classList.add('w-full')
                div.classList.add('mt-4')
                div.classList.add('mb-4')
                div.classList.add('p-4')
                div.innerHTML = item.innerHTML
                item.parentNode.insertBefore(div, item.nextSibling)
                item.style.display = 'none'
              })
              _.each(document.getElementsByTagName('h4'), (item, i) => {
                item.classList.add('font-title')
                item.classList.add('text-1xl')
                item.classList.add('md:text-1xl')
                item.classList.add('lg:text-2xl')
                item.classList.add('mt-2')
                item.classList.add('mb-2')
                item.classList.add('pt-2')
              })
              _.each(document.getElementsByTagName('h3'), (item, i) => {
                item.classList.add('font-title')
                item.classList.add('text-1xl')
                item.classList.add('md:text-1xl')
                item.classList.add('lg:text-2xl')
                item.classList.add('mt-2')
                item.classList.add('mb-2')
                item.classList.add('pt-2')
              })
              _.each(document.getElementsByTagName('h2'), (item, i) => {
                item.classList.add('font-title')
                item.classList.add('text-1xl')
                item.classList.add('md:text-2xl')
                item.classList.add('lg:text-3xl')
                item.classList.add('mt-4')
                item.classList.add('mb-2')
                item.classList.add('pt-2')
              })
              _.each(document.getElementsByTagName('h1'), (item, i) => {
                item.classList.add('font-title')
                item.classList.add('text-2xl')
                item.classList.add('md:text-3xl')
                item.classList.add('lg:text-4xl')
                item.classList.add('mt-4')
                item.classList.add('mb-2')
                item.classList.add('pt-2')
              })
            })
        }

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

      event.target.classList.add('active')
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
