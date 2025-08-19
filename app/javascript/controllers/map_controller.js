import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input","map","marker"]

  connect() {
    if (typeof google === 'undefined') {
      // 等待 Maps API 載入完成後再初始化
      window.addEventListener("google-maps-ready", this.init.bind(this))
    } else {
      this.init()
    }
  }

  init() {
    this.initAutocomplete()
    this.initMap()
  }

  initAutocomplete() {
    this.autocomplete = new google.maps.places.Autocomplete(this.inputTarget)
    this.autocomplete.addListener("place_changed", () => {
      const place = this.autocomplete.getPlace()
      if (place.geometry) {
        this.map.setCenter(place.geometry.location)
        this.marker.setPosition(place.geometry.location)
      }
    })
  }

  initMap() {
    const defaultLatLng = { lat: 25.033964, lng: 121.564468 }

    this.map = new google.maps.Map(document.getElementById("map"), {
      center: defaultLatLng,
      zoom: 15,
    })

    this.marker = new google.maps.Marker({
      map: this.map,
      position: defaultLatLng,
      draggable: true,
    })

    this.map.addListener("click", (e) => {
      this.marker.setPosition(e.latLng)
      this.reverseGeocode(e.latLng)
    })
  }

  reverseGeocode(latlng) {
    const geocoder = new google.maps.Geocoder()
    geocoder.geocode({ location: latlng }, (results, status) => {
      if (status === "OK" && results[0]) {
        this.inputTarget.value = results[0].formatted_address
      }
    })
  }
}
