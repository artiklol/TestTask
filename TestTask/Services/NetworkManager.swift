//
//  NetworkManager.swift
//  TestTask
//
//  Created by Artem Sulzhenko on 24.09.2023.
//

import UIKit

final class NetworkManager {

    static let shared = NetworkManager()
    private let jsonDecoder = JSONDecoder()

    func fetchContent(page: Int, completion: @escaping (Result<[Content], Error>) -> Void) {
        let urlContent = "https://junior.balinasoft.com/api/v2/photo/type?page=\(page)"
        guard let url = URL(string: urlContent) else { return }
        URLSession.shared.dataTask(with: url) { [jsonDecoder] data, _, _ in
            guard let data else { return }
            guard let content = try? jsonDecoder.decode(ReceivedData.self, from: data) else { return }

            DispatchQueue.main.async {
                completion(.success(content.content))
            }
        }.resume()
    }

    func sendContent(name: String, photo: UIImage, typeId: Int) {
        guard let url = URL(string: "https://junior.balinasoft.com/api/v2/photo/") else { return }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"

        let uuidString = UUID().uuidString
        request.setValue("multipart/form-data; boundary=\(uuidString)", forHTTPHeaderField: "Content-Type")
        let boundary = "--\(uuidString)\r\n"
        let endingBoundary = "--\(uuidString)--\r\n"

        var data = Data()

        data.append(boundary.data(using: .utf8)!)
        data.append("Content-Disposition: form-data; name=\"name\"\r\n\r\n".data(using: .utf8)!)
        data.append("\(name)\r\n".data(using: .utf8)!)

        data.append(boundary.data(using: .utf8)!)
        data.append("Content-Disposition: form-data; name=\"photo\"; filename=\"\(typeId).jpg\"\r\n".data(using: .utf8)!)
        data.append("Content-Type: image/jpeg\r\n\r\n".data(using: .utf8)!)
        data.append(photo.jpegData(compressionQuality: 0.8)!)
        data.append("\r\n".data(using: .utf8)!)

        data.append(boundary.data(using: .utf8)!)
        data.append("Content-Disposition: form-data; name=\"typeId\"\r\n\r\n".data(using: .utf8)!)
        data.append("\(typeId)\r\n".data(using: .utf8)!)

        data.append(endingBoundary.data(using: .utf8)!)

        URLSession.shared.uploadTask(with: request, from: data) { data, response, error in
            if let error = error {
                print("Upload failed with error: \(error.localizedDescription)")
            }

            if let response = response as? HTTPURLResponse {
                print(response)
            }
        }.resume()
    }
}
