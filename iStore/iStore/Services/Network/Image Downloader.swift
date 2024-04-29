import UIKit
import Kingfisher

final class ImageDownloader {

    static let shared = ImageDownloader()

    private init() {}

    func downloadImage(from url: URL, completion: @escaping (Result<UIImage, Error>) -> Void) {
        let imageView = UIImageView()
        imageView.kf.setImage(with: url, completionHandler: { result in
            switch result {
            case .success(let value):
                completion(.success(value.image))
            case .failure(let error):
                completion(.failure(error))
            }
        })
    }
}
