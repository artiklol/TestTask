//
//  PhotoListCollectionViewCell.swift
//  TestTask
//
//  Created by Artem Sulzhenko on 24.09.2023.
//

import UIKit

final class PhotoListCollectionViewCell: UICollectionViewCell {
    private lazy var coverImageView: CoverImageView = {
        let imageView = CoverImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.shadowColor = UIColor.black.cgColor
        imageView.layer.shadowOpacity = 0.7
        imageView.layer.shadowOffset = CGSizeZero
        imageView.layer.shadowRadius = 5
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private lazy var elementNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.numberOfLines = 2
        label.font = UIFont.boldSystemFont(ofSize: 12.0)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    var viewModel: PhotoListCollectionViewCellViewModelProtocol? {
        didSet {
            elementNameLabel.text = viewModel?.elementName
            if let url = viewModel?.urlImage {
                coverImageView.fetchImage(with: url)
            }
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        addSubview()
        configureLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        coverImageView.image = nil
    }

    private func addSubview() {
        [coverImageView, elementNameLabel].forEach(contentView.addSubview)
    }

    private func configureLayout() {
        NSLayoutConstraint.activate([
            coverImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            coverImageView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 5),
            coverImageView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -5),
            coverImageView.heightAnchor.constraint(equalToConstant: 120),

            elementNameLabel.topAnchor.constraint(equalTo: coverImageView.bottomAnchor, constant: 5),
            elementNameLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 3),
            elementNameLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -3)
        ])
    }
}
