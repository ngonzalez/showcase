import { Controller } from '@hotwired/stimulus'
import _ from 'lodash'

export default class extends Controller {
  static targets = [ 'validateForm' ]

  connect() {
    console.log('connect')
  }
}
