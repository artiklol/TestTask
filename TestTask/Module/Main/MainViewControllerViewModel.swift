//
//  MainViewControllerViewModel.swift
//  TestTask
//
//  Created by Artem Sulzhenko on 24.09.2023.
//

import Foundation

protocol MainViewControllerViewModelProtocol {
    func fetchContent(page: Int, completion: @escaping () -> Void)
    func fetchNextPageContent(page: Int, completion: @escaping () -> Void)
    func numberOfItems() -> Int
    func cellViewModel(at indexPath: IndexPath) -> PhotoListCollectionViewCellViewModelProtocol
    func selectedCell(for indexPath: IndexPath)
    func selectedId() -> Int 
}

final class MainViewControllerViewModel: MainViewControllerViewModelProtocol {

    private var content = [Content]()
    private var indexPath = IndexPath()
    private var id = Int()

    func fetchContent(page: Int, completion: @escaping () -> Void) {
        NetworkManager.shared.fetchContent(page: page) { [weak self] result in
            switch result {

            case .success(let content):
                self?.content = content
                completion()
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }

    func fetchNextPageContent(page: Int, completion: @escaping () -> Void) {
        NetworkManager.shared.fetchContent(page: page) { [weak self] result in
            switch result {

            case .success(let content):
                self?.content += content
                completion()
            case .failure(let error):
                print(error.localizedDescription )
            }
        }
    }

    func numberOfItems() -> Int {
        content.count
    }

    func cellViewModel(at indexPath: IndexPath) -> PhotoListCollectionViewCellViewModelProtocol {
        PhotoListCollectionViewCellViewModel(element: content[indexPath.row])
    }

    func selectedCell(for indexPath: IndexPath) {
        self.indexPath = indexPath
        self.id = content[indexPath.row].id
    }

    func selectedId() -> Int {
        id
    }
}
