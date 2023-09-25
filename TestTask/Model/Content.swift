//
//  Content.swift
//  TestTask
//
//  Created by Artem Sulzhenko on 24.09.2023.
//

import UIKit

// MARK: - ReceivedData
struct ReceivedData: Decodable {
    let content: [Content]
}

// MARK: - Content
struct Content: Decodable {
    let id: Int
    let name: String
    let image: URL?
}
