import { Controller } from '@hotwired/stimulus'
import { marked } from 'marked';
import _ from 'lodash'

const documentation = {
  "#documentation-index": "https://link12.ddns.net:4040/attachment/3?type=TextFile",
  "#desktop-application": "https://link12.ddns.net:4040/attachment/1?type=TextFile"
}

export default class extends Controller {
  static targets = [ 'documentationPage']

  connect() {
    this.clearMenuLinks()
    _.each(document.getElementById('documentationMenu').querySelectorAll('a.menu-link'), (element, index) => {
      let href = element.getAttribute('href')
      if (href == document.location.hash) {
        this.toggleStatus(element)
        if (documentation[href]) {
          this.getTextFile(href)
        }
      }
    })
  }

  clickSidebarMenu(event) {
    let href = event.target.getAttribute('href')
    if (href) {
      this.clearMenuLinks()
      this.toggleStatus(event.target)
    }
  }

  toggleStatus(element) {
    element.classList.add('active')
    let statusElement = element.querySelectorAll('[aria-label="status"]')[0]
    if (typeof statusElement != 'undefined') {
      statusElement.style.visibility = 'visible'
    }

    let statusAnimatedElement = element.querySelectorAll('[aria-label="status-animated"]')[0]
    if (typeof statusAnimatedElement != 'undefined') {
      statusAnimatedElement.style.visibility = 'visible'
    }
  }

  clearMenuLinks() {
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
  }

  getTextFile(href) {
    axios
      .get(documentation[href], {
        headers: {
          "Content-Type": "application/json"
        },
      })
      .then((response) => {
        let container = this.documentationPageTarget.querySelectorAll('[name="container"]')[0]
        container.innerHTML = marked.parse(response.data)
        this.formatText(container)
      })
  }

  formatText(container) {
    _.each(container.getElementsByTagName('a'), (item, i) => {
      if (item['href'].match(/\#/i)) {
        item.removeAttribute('href')
      }
    })
    _.each(container.getElementsByTagName('pre'), (item, i) => {
      item.classList.add('shadow-sm')
      item.classList.add('w-full')
    })
    _.each(container.getElementsByTagName('table'), (item, i) => {
      item.classList.add('shadow-sm')
    })
    _.each(container.getElementsByTagName('h4'), (item, i) => {
      item.classList.add('font-title')
      item.classList.add('text-1xl')
      item.classList.add('md:text-1xl')
      item.classList.add('lg:text-2xl')
      item.classList.add('mt-2')
      item.classList.add('mb-2')
      item.classList.add('pt-2')
    })
    _.each(container.getElementsByTagName('h3'), (item, i) => {
      item.classList.add('font-title')
      item.classList.add('text-1xl')
      item.classList.add('md:text-1xl')
      item.classList.add('lg:text-2xl')
      item.classList.add('mt-2')
      item.classList.add('mb-2')
      item.classList.add('pt-2')
    })
    _.each(container.getElementsByTagName('h2'), (item, i) => {
      item.classList.add('font-title')
      item.classList.add('text-1xl')
      item.classList.add('md:text-2xl')
      item.classList.add('lg:text-3xl')
      item.classList.add('mt-4')
      item.classList.add('pt-2')
    })
    _.each(container.getElementsByTagName('h1'), (item, i) => {
      item.classList.add('font-title')
      item.classList.add('text-2xl')
      item.classList.add('md:text-3xl')
      item.classList.add('lg:text-4xl')
      item.classList.add('mt-4')
      item.classList.add('pt-2')
    })
  }
}
