//
//  PhotoListCollectionViewCellViewModel.swift
//  TestTask
//
//  Created by Artem Sulzhenko on 24.09.2023.
//

import Foundation

protocol PhotoListCollectionViewCellViewModelProtocol {
    var elementName: String { get }
    var urlImage: URL? { get }
    init(element: Content)
}

final class PhotoListCollectionViewCellViewModel: PhotoListCollectionViewCellViewModelProtocol {

    private let element: Content

    var elementName: String {
        return element.name
    }

    var urlImage: URL? {
        return element.image
    }

    required init(element: Content) {
        self.element = element
    }

}
