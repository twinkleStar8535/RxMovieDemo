//
//  MovieSimilaritiesCell.swift
//  RxMovieDemoApp
//
//  Created by YcLin on 2025/4/2.
//

import UIKit
import Kingfisher

class MovieSimilaritiesCell: UICollectionViewCell {
    private var rateLabel:UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 12,weight: .medium)
        label.numberOfLines = 1
        return label
    }()


    private let contentImgView:UIImageView = {
        let imgView = UIImageView()
        imgView.isUserInteractionEnabled = true
        return imgView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupTheme()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configCell(imgURL:String,voteRate:Double) {
        self.addSubview(contentImgView)
        contentImgView.layer.cornerRadius = 16
        contentImgView.clipsToBounds = true
        contentImgView.addSubview(rateLabel)
        rateLabel.layer.cornerRadius = 8
        rateLabel.clipsToBounds = true

        if let url = URL(string: MovieUseCase.configureUrlString(imagePath: imgURL)!) {
            let imageResource = KF.ImageResource(downloadURL: url)
            contentImgView.kf.setImage(with: imageResource,placeholder: UIImage(named: "noImageYet"))
        }

        rateLabel.text = String(format: "%.1f", voteRate)

        contentImgView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
        }

        rateLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(5)
            make.left.equalToSuperview().offset(8)
            make.width.equalTo(30)
            make.height.equalTo(25)
        }
    }
}


extension MovieSimilaritiesCell:ThemeChangeDelegate {
    func setupTheme() {
        self.theme.backgroundColor = themeService.attribute {$0.backgroundColor}
        rateLabel.theme.backgroundColor = themeService.attribute {$0.tabBarSelectColor}
    }
}
