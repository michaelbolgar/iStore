import UIKit

final class ImageDownloader {

    static let shared = ImageDownloader()

    private init() {}

    func downloadImage(from url: URL, completion: @escaping (Result<UIImage, Error>) -> Void)  {

        URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
            guard self != nil else { return }
            if let error = error {
                DispatchQueue.main.async {
                    print("Error downloading image")
                    completion(.failure(error))
                }
                return
            }

            if let data = data, let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    completion(.success(image))
                }
            } else {
                print("Invalid image data")
            }
        }.resume()
    }
}
