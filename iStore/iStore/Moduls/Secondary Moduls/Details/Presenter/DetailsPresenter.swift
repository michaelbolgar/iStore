import Foundation

protocol DetailsPresenterProtocol {
    func getData()
}

final class DetailsPresenter: DetailsPresenterProtocol {
    var detailProduct: DetailsModel?
       weak var view: DetailsVCProtocol?
    init(view: DetailsVCProtocol? = nil) {
        self.view = view
    }
    func getData() {

        detailProduct  = DetailsModel(productImage: "img", 
                                      productLabel: "Air pods max by Apple",
                                      priceLabel: 1999.99,
                                      isFavorited: false,
                                      descriptionProduct: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aliquet arcu id tincidunt tellus arcu rhoncus, turpis nisl sed. Neque viverra ipsum orci, morbi semper. Nulla bibendum purus tempor semper purus. Ut curabitur platea sed blandit. Amet non at proin justo nulla et. A, blandit morbi suspendisse vel malesuada purus massa mi. Faucibus neque a mi hendrerit. Audio Technology Apple-designed dynamic driver Active Noise Cancellation Transparency mode Adaptive EQ Spatial audio with dynamic head tracking1 Sensors Optical sensor (each ear cup) Position sensor (each ear cup) Case-detect sensor (each ear cup) Accelerometer (each ear cup) Gyroscope (left ear cup) Microphones Nine microphones total: Eight microphones for Active Noise Cancellation Three microphones for voice pickup (two shared with Active Noise Cancellation and one additional microphone) Chip Apple H1 headphone chip (each ear cup) Controls Digital Crown Turn for volume control Press once to play, pause or answer a phone call Press twice to skip forwards Press three times to skip back Press and hold for Siri Noise control button Press to switch between Active Noise Cancellation and Transparency mode Size and Weight2 AirPods Max, including cushions Weight: 384.8g Smart Case Weight: 134.5g Battery AirPods Max Up to 20 hours of listening time on a single charge with Active Noise Cancellation or Transparency mode")

        guard let detailProduct = detailProduct else { return }
        view?.displayDetails(for: detailProduct)

    }
}

