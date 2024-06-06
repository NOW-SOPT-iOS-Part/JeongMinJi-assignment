//
//  MainLogoHeaderView.swift
//  34th-Sopt-Assignment
//
//  Created by 정민지 on 4/22/24.
//

import UIKit

final class MainLogoHeaderView: UIView {
    // MARK: - Properties
    private let tvingImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = .tvingLogo1
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    private let doosanImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = .doosanLogo
        imageView.contentMode = .scaleAspectFit
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
        [ tvingImageView, doosanImageView].forEach {
            self.addSubview($0)
        }
        tvingImageView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().inset(11)
            $0.width.equalTo(99)
            $0.height.equalTo(25)
        }
        doosanImageView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(9)
            $0.width.equalTo(33)
            $0.height.equalTo(41)
        }
    }
}
