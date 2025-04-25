//
//  TrailerTableViewCell.swift
//  RxMovieDemoApp
//
//  Created by YcLin on 2025/3/25.
//

import UIKit
import Kingfisher
import SnapKit
import RxTheme

class TrailerTableViewCell: UITableViewCell {

    private let thumbnailImgView:UIImageView = {
        let imgView = UIImageView()
        imgView.contentMode = .scaleAspectFit
        return imgView
    }()


    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        label.numberOfLines = 2
        label.sizeToFit()
        return label
    }()

    private let timeLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.textColor = .lightGray
        label.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setLayout()
        setupTheme()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func confireCell(thumbnailStr:String,titleStr:String,timeStr:String) {
        let thumbNailURL = URL(string:MovieUseCase.configureUrlString(thumbnailKey: thumbnailStr))!
        let resource = KF.ImageResource(downloadURL: thumbNailURL)
        thumbnailImgView.kf.setImage(with: resource)
        titleLabel.text = titleStr
        titleLabel.theme.textColor = themeService.attribute {$0.textColor}
        timeLabel.text = String(timeStr.prefix(10))
    }


    func setLayout() {
        contentView.addSubview(thumbnailImgView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(timeLabel)

        thumbnailImgView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(15)
            make.centerY.equalToSuperview()
            make.top.bottom.equalToSuperview().inset(10)
            make.width.equalTo(thumbnailImgView.snp.height).multipliedBy(1.5)
        }

        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(thumbnailImgView.snp.top).offset(15)
            make.left.equalTo(thumbnailImgView.snp.right).offset(10)
            make.right.equalTo(self.contentView.snp.right).offset(-10)
        }


        timeLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.left.equalTo(thumbnailImgView.snp.right).offset(10)
            make.right.equalTo(self.contentView.snp.right).offset(-10)
            make.bottom.equalTo(self.contentView.snp.bottom).offset(-10)
        }


    }

}


extension TrailerTableViewCell:ThemeChangeDelegate {
    func setupTheme() {
        self.theme.backgroundColor = themeService.attribute {$0.backgroundColor}
        self.titleLabel.theme.textColor = themeService.attribute {$0.textColor}
    }
}
