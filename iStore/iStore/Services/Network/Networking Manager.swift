import Foundation

enum NetworkError: Error {
    case transportError(Error)
    case serverError(statusCode: Int)
    case noData
    case decodingError(Error)
}

struct NetworkingManager {
    
    static let shared = NetworkingManager()
    
    private init() {}
    
    //MARK: - Private Methods
    
    private func createURL (for endPoint: Endpoint, with query: String? = nil) -> URL? {
        var components = URLComponents()
        components.scheme = API.scheme
        components.host = API.host
        components.path = endPoint.path
        
        /// add parameters for limitation of requests, eg: how many items get in every request
        components.queryItems = makeParameters(for: endPoint, with: query).compactMap {
            URLQueryItem(name: $0.key, value: $0.value)
        }
        
        ///print generated url
        //      print("URL: \(String(describing: components.url))")
        
        return components.url
    }
    
    /// Make dictionary of parameters for URL request
    private func makeParameters(for endpoint: Endpoint, with query: String?) -> [String: String] {
        var parameters = [String: String]()
        
        switch endpoint {
            
        case .getCategories:
            parameters ["offset"] = "0"
            parameters ["limit"] = "6"
            
        case .getProductsByCategory:
            parameters ["offset"] = "0"
            parameters ["limit"] = "10"
            
        case .getProduct(id: let id):
            parameters ["id"] = "\(id)"
            
        case .doSearch (request: let request):
            parameters ["offset"] = "0"
            parameters ["limit"] = "15"
            parameters ["title"] = "\(request)"
        case .updateCategory(id: let id):
            parameters ["id"] = "\(id)"
        case .deleteProduct(id: let id):
            parameters ["id"] = "\(id)"
        }
        
        return parameters
    }
    
    private func makeTask<T: Codable>(for url: URL, using session: URLSession = .shared, completion: @escaping(Result<T, NetworkError>) -> Void) {
        
        var request = URLRequest(url: url)
        
        
        ///print generated url
        //        print("URL: \(String(describing: components.url))")
        
        session.dataTask(with: request) {data, response, error in
            
            if let error = error {
                completion(.failure(.transportError(error)))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                let error = NSError(domain: "No HTTPURLResponse", code: 0, userInfo: nil)
                completion(.failure(.serverError(statusCode: error.code)))
                return
            }
            
            let statusCode = httpResponse.statusCode
            
            /// Error handling: authorization error
            //            /// Error handling: daily request limit exceeded
            //            if statusCode == 403 {
            //                let exceededLimitError = NSError(domain: "Forbidden", code: 403, userInfo: nil)
            //                completion(.failure(.serverError(statusCode: statusCode)))
            //                print ("Error \(statusCode). Daily request limit exceeded")
            //                return
            //            }
            
            guard let data = data else {
                let error =  NSError(domain: "No data", code: 0, userInfo: nil)
                completion(.failure(.noData))
                return
            }
            
            //            if let responseDataString = String(data: data, encoding: .utf8) {
            //                    print("Response Data: \(responseDataString)")
            //                } else {
            //                    print("Failed to convert response data to string")
            //                }
            
            do {
                let decodeData = try JSONDecoder().decode(T.self, from: data)
                completion(.success(decodeData))
            } catch {
                completion(.failure(.decodingError(error)))
            }
        }.resume()
    }
    
    //MARK: - Public Methods
    
    /// Get categories for HomeScreen
    func getCategories(completion: @escaping(Result<[Category], NetworkError>) -> Void) {
        guard let url = createURL(for: .getCategories) else { return }
        makeTask(for: url, completion: completion)
    }
    
    /// Get products by category
    func getProductsByCategory(for id: Int, completion: @escaping(Result<[SingleProduct], NetworkError>) -> Void) {
        guard let url = createURL(for: .getProductsByCategory(id: id)) else { return }
        makeTask(for: url, completion: completion)
    }
    
    /// Get products by category
    func getProduct(for id: Int, completion: @escaping(Result<SingleProduct, NetworkError>) -> Void) {
        guard let url = createURL(for: .getProduct(id: id)) else { return }
        makeTask(for: url, completion: completion)
    }
    
    /// search by title
    func doSearch(for request: String, completion: @escaping(Result<[SingleProduct], NetworkError>) -> Void) {
        guard let url = createURL(for: .doSearch(request: request)) else { return }
        makeTask(for: url, completion: completion)
    }
}

extension NetworkingManager {
    func updateProduct(id: Int, newTitle: String, newPrice: Int, newDescription: String, newCategory: String, completion: @escaping(Result<Void, NetworkError>) -> Void) {
        guard let url = URL(string: "https://api.escuelajs.co/api/v1/products/\(id)") else {
            completion(.failure(.noData))
            return
        }
        
        // Создание JSON-тела запроса
        let body: [String: Any] = [
            "title": newTitle,
            "price": newPrice,
            "description": newDescription,
            "category": ["name": newCategory]
            
        ]
        
        // Преобразование JSON-тела в Data
        guard let jsonData = try? JSONSerialization.data(withJSONObject: body) else {
            completion(.failure(.noData))
            return
        }
        
        // Создание запроса
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData
        
        // Отправка запроса
        URLSession.shared.dataTask(with: request) { _, response, error in
            if let error = error {
                completion(.failure(.transportError(error)))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(.noData))
                return
            }
            
            let statusCode = httpResponse.statusCode
            
            if (200..<300).contains(statusCode) {
                // Обновление выполнено успешно
                completion(.success(()))
            } else {
                // Произошла ошибка на сервере
                completion(.failure(.serverError(statusCode: statusCode)))
            }
        }.resume()
    }
    
    // MARK: - deleteProduct
    func deleteProduct(id: Int, completion: @escaping(Result<Bool, NetworkError>) -> Void) {
        guard let url = URL(string: "https://api.escuelajs.co/api/v1/products/\(id)") else {
            completion(.failure(.noData))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(.transportError(error)))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(.noData))
                return
            }
            
            let statusCode = httpResponse.statusCode
            
            if (200..<300).contains(statusCode) {
                // Удаление выполнено успешно
                completion(.success(true))
            } else {
                // Произошла ошибка на сервере
                completion(.failure(.serverError(statusCode: statusCode)))
            }
        }.resume()
    }
    
    // MARK: - createProduct
    func createProduct(title: String, price: Int, description: String, categoryId: Int, images: [String], completion: @escaping(Result<Void, NetworkError>) -> Void) {
        guard let url = URL(string: "https://api.escuelajs.co/api/v1/products/") else {
            completion(.failure(.noData))
            return
        }
        
        // Создание JSON-тела запроса
        let body: [String: Any] = [
            "title": title,
            "price": price,
            "description": description,
            "categoryId": categoryId,
            "images": images
        ]
        
        // Преобразование JSON-тела в Data
        guard let jsonData = try? JSONSerialization.data(withJSONObject: body) else {
            completion(.failure(.noData))
            return
        }
        
        // Создание запроса
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData
        
        // Отправка запроса
        URLSession.shared.dataTask(with: request) { _, response, error in
            if let error = error {
                completion(.failure(.transportError(error)))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(.noData))
                return
            }
            
            let statusCode = httpResponse.statusCode
            
            if (200..<300).contains(statusCode) {
                // Создание выполнено успешно
                completion(.success(()))
            } else {
                // Произошла ошибка на сервере
                completion(.failure(.serverError(statusCode: statusCode)))
            }
        }.resume()
    }
}






//struct UpdatedProduct: Codable {
//    let name: String?
//    let image: String?
//}
//
//extension NetworkingManager {
//        
//        /// Update product by ID
//        func updateProduct(withId id: Int, newData: UpdatedProduct, completion: @escaping(Result<UpdatedProduct, NetworkError>) -> Void) {
//            guard let url = createURL(for: .getProduct(id: id)) else { return }
//            var request = URLRequest(url: url)
//            request.httpMethod = "PUT"
//            
//            do {
//                request.httpBody = try JSONEncoder().encode(newData)
//            } catch {
//                completion(.failure(.decodingError(error)))
//                return
//            }
//            let session = URLSession.shared
//            session.dataTask(with: request) { data, response, error in
//                if let error = error {
//                    completion(.failure(.transportError(error)))
//                    return
//                }
//                
//                guard let httpResponse = response as? HTTPURLResponse else {
//                    let error = NSError(domain: "No HTTPURLResponse", code: 0, userInfo: nil)
//                    completion(.failure(.serverError(statusCode: error.code)))
//                    return
//                }
//                
//                let statusCode = httpResponse.statusCode
//                
//                guard let data = data else {
//                    let error = NSError(domain: "No data", code: 0, userInfo: nil)
//                    completion(.failure(.noData))
//                    return
//                }
//                
//                do {
//                    let updatedProduct = try JSONDecoder().decode(UpdatedProduct.self, from: data)
//                    let updatedData = UpdatedProduct(name: updatedProduct.name, image: updatedProduct.image)
//                    completion(.success(updatedData))
//                } catch {
//                    completion(.failure(.decodingError(error)))
//                }
//
//
//            }.resume()
//        }
//    }


    /// Update category by ID
//    func updateCategory(withId id: Int, newData: UpdatedProduct, completion: @escaping(Result<Category, NetworkError>) -> Void) {
//        guard let url = createURL(for: .updateCategory(id: id)) else { return }
//
//        var request = URLRequest(url: url)
//        request.httpMethod = "PUT"
//
//        do {
//            request.httpBody = try JSONEncoder().encode(newData)
//        } catch {
//            completion(.failure(.decodingError(error)))
//            return
//        }
//        let session = URLSession.shared
//        session.dataTask(with: request) { data, response, error in
//            if let error = error {
//                completion(.failure(.transportError(error)))
//                return
//            }
//
//            guard let httpResponse = response as? HTTPURLResponse else {
//                let error = NSError(domain: "No HTTPURLResponse", code: 0, userInfo: nil)
//                completion(.failure(.serverError(statusCode: error.code)))
//                return
//            }
//
//            let statusCode = httpResponse.statusCode
//
//            guard let data = data else {
//                let error = NSError(domain: "No data", code: 0, userInfo: nil)
//                completion(.failure(.noData))
//                return
//            }
//
//            do {
//                let updatedCategory = try JSONDecoder().decode(Category.self, from: data)
//                completion(.success(updatedCategory))
//            } catch {
//                completion(.failure(.decodingError(error)))
//            }
//        }.resume()
//    }

