//
//  Reusable.swift
//  TestTask
//
//  Created by Artem Sulzhenko on 24.09.2023.
//

import UIKit

protocol Reusable {
    static var identifier: String { get }
}

extension Reusable {
    static var identifier: String {
        String(describing: Self.self)
    }
}

extension UICollectionViewCell: Reusable {
    
}
