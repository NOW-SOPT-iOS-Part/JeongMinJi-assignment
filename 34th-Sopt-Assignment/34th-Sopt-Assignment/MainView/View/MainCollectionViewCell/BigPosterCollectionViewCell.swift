//
//  BigPosterCollectionViewCell.swift
//  34th-Sopt-Assignment
//
//  Created by 정민지 on 4/21/24.
//

import UIKit

final class BigPosterCollectionViewCell: UICollectionViewCell {
    // MARK: - Properties
    private let moviePosterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = .bigPoster1
        imageView.contentMode = .scaleToFill
        return imageView
    }()
    private let moviePosterShadowImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = .bigPosterShadow
        imageView.contentMode = .scaleToFill
        return imageView
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
        [ moviePosterImageView, moviePosterShadowImageView].forEach {
            self.addSubview($0)
        }

        moviePosterImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        moviePosterShadowImageView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview().inset(-4)
            $0.height.equalTo(moviePosterShadowImageView.snp.width).multipliedBy(94.0 / 375.0)
        }   
    }
}
