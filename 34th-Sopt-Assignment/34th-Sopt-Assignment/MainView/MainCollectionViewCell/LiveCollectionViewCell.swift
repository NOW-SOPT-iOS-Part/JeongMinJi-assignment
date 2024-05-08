//
//  LiveCollectionViewCell.swift
//  34th-Sopt-Assignment
//
//  Created by 정민지 on 4/21/24.
//

import UIKit

final class LiveCollectionViewCell: UICollectionViewCell {
    // MARK: - Properties    
    private let liveImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = .livePoster1
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = 3
        return imageView
    }()
    private let numberLabel: UILabel = {
        let label = UILabel()
        label.text = "1"
        label.textColor = .white
        return label
    }()
    private let channelLabel: UILabel = {
        let label = UILabel()
        label.text = "Mnet"
        label.textColor = .white
        label.textAlignment = .left
        label.numberOfLines = 1
        label.font = .pretendard(to: .regular, size: 10)
        return label
    }()
    private let subTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "보이즈 플래닛 12화"
        label.textColor = .gray2
        label.textAlignment = .left
        label.numberOfLines = 1
        label.font = .pretendard(to: .regular, size: 10)
        return label
    }()
    private let ratingLabel: UILabel = {
        let label = UILabel()
        label.text = "80.0%"
        label.textColor = .gray2
        label.textAlignment = .left
        label.numberOfLines = 1
        label.font = .pretendard(to: .regular, size: 10)
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
        [liveImageView, numberLabel, channelLabel, subTitleLabel, ratingLabel].forEach {
            self.addSubview($0)
        }
        liveImageView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(liveImageView.snp.width).multipliedBy(0.5)
        }
        numberLabel.snp.makeConstraints {
            $0.top.equalTo(liveImageView.snp.bottom).offset(8)
            $0.leading.equalToSuperview().offset(8)
            $0.width.equalTo(12)
        }
        channelLabel.snp.makeConstraints {
            $0.top.equalTo(liveImageView.snp.bottom).offset(11)
            $0.leading.equalTo(numberLabel.snp.trailing).offset(2.12)
            $0.trailing.equalToSuperview()
        }
        subTitleLabel.snp.makeConstraints {
            $0.top.equalTo(channelLabel.snp.bottom)
            $0.leading.equalTo(channelLabel.snp.leading)
            $0.trailing.equalToSuperview()
        }
        ratingLabel.snp.makeConstraints {
            $0.top.equalTo(subTitleLabel.snp.bottom)
            $0.leading.equalTo(channelLabel.snp.leading)
            $0.trailing.equalToSuperview()
        }
    }
}


extension LiveCollectionViewCell {
    func dataBind(_ itemData: LiveModel, index: Int) {
        liveImageView.image = itemData.posterImage
        numberLabel.text = "\(index)"
        channelLabel.text = itemData.channelTitle
        subTitleLabel.text = itemData.subTitle
        ratingLabel.text = "\(itemData.rating)%"

    }
}


