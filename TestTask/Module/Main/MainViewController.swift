//
//  ViewController.swift
//  TestTask
//
//  Created by Artem Sulzhenko on 24.09.2023.
//

import UIKit

final class MainViewController: UIViewController {
    
    private lazy var photoListCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    private var viewModel = MainViewControllerViewModel() {
        didSet {
            viewModel.fetchContent(page: currentPage) {
                DispatchQueue.main.async {
                    self.photoListCollectionView.reloadData()
                }
            }
        }
    }
    
    private var currentPage = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = MainViewControllerViewModel()
        
        addSubview()
        configureLayout()
        configureCollectionView()
    }
    
    private func addSubview() {
        [photoListCollectionView].forEach(view.addSubview)
    }
    
    private func configureLayout() {
        NSLayoutConstraint.activate([
            photoListCollectionView.topAnchor.constraint(equalTo: view.topAnchor),
            photoListCollectionView.leftAnchor.constraint(equalTo: view.leftAnchor),
            photoListCollectionView.rightAnchor.constraint(equalTo: view.rightAnchor),
            photoListCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func configureCollectionView() {
        photoListCollectionView.register(PhotoListCollectionViewCell.self,
                                         forCellWithReuseIdentifier: PhotoListCollectionViewCell.identifier)
        photoListCollectionView.dataSource = self
        photoListCollectionView.delegate = self
    }
}

extension MainViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {        return viewModel.numberOfItems()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: PhotoListCollectionViewCell.identifier,
            for: indexPath) as? PhotoListCollectionViewCell else {
            return PhotoListCollectionViewCell()
        }
        
        cell.viewModel = viewModel.cellViewModel(at: indexPath)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row == (viewModel.numberOfItems()) - 1 {
            currentPage = currentPage + 1
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                self.viewModel.fetchNextPageContent(page: self.currentPage) {
                    self.photoListCollectionView.reloadData()
                }
            }
        }
    }
}

extension MainViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel.selectedCell(for: indexPath)
        let picker = UIImagePickerController()
        picker.sourceType = .camera
        picker.delegate = self
        present(picker, animated: true)
    }
}

extension MainViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let availableWidth = view.bounds.width - 120
        let cellWidth = (availableWidth / 2) + 10
        return CGSize(width: cellWidth, height: 180)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
    }
}

extension MainViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        picker.dismiss(animated: true)
        guard let image = info[.originalImage] as? UIImage else { return }
        let fullName = "Сульженко Артем Анатольевич"
        NetworkManager.shared.sendContent(name: fullName, photo: image, typeId: viewModel.selectedId())
    }
}
