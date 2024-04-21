//
//  MovieFooterCollectionReusableView.swift
//  34th-Sopt-Assignment
//
//  Created by 정민지 on 4/22/24.
//

import UIKit

final class MovieFooterCollectionReusableView: UICollectionReusableView {
    // MARK: - Properties
    static let identifier = "MovieFooterCollectionReusableView"

    private let advertisementImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = .llo
        imageView.contentMode = .scaleToFill
        return imageView
    }()
    
    // MARK: - init
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setLayout()
    }
    override func layoutSubviews() {
            super.layoutSubviews()
            self.frame = self.frame.offsetBy(dx: -15, dy: 0)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - SetLayout
    private func setLayout() {
        self.addSubview(advertisementImageView)
        
        advertisementImageView.snp.makeConstraints {
            $0.centerY.leading.equalToSuperview()
            $0.trailing.equalToSuperview().offset(15)
            $0.height.equalTo(advertisementImageView.snp.width).multipliedBy(58.0 / 375.0)
        }
    }
}
