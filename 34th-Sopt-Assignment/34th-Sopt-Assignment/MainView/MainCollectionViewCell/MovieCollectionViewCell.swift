//
//  MovieCollectionViewCell.swift
//  34th-Sopt-Assignment
//
//  Created by 정민지 on 4/21/24.
//


import UIKit

final class  MovieCollectionViewCell: UICollectionViewCell {
    // MARK: - Properties
    static let identifier = "MovieCollectionViewCell"
    
    private let moviePosterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = .moviePoster1
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = 3
        return imageView
    }()
    private let movieTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "시그널"
        label.textColor = .gray2
        label.textAlignment = .left
        label.numberOfLines = 1
        label.font = .pretendard(to: .medium, size: 10)
        return label
    }()

    // MARK: - init
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - SetLayout
    private func setLayout() {
        [moviePosterImageView, movieTitleLabel].forEach {
            self.addSubview($0)
        }
        moviePosterImageView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(1)
            $0.height.equalTo(moviePosterImageView.snp.width).multipliedBy(146.0 / 98.0)
        }
        movieTitleLabel.snp.makeConstraints {
            $0.top.equalTo( moviePosterImageView.snp.bottom).offset(3)
            $0.leading.trailing.equalToSuperview()
        }
    }
}


extension MovieCollectionViewCell {
    func dataBind(_ itemData: MovieModel) {
        moviePosterImageView.image = itemData.posterImage
        movieTitleLabel.text = itemData.title
    }
}
