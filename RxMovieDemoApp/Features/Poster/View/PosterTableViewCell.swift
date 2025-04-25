//
//  PosterTableViewCell.swift
//  RxMovieDemoApp
//
//  Created by YcLin on 2025/3/26.
//

import UIKit
import Kingfisher
import SnapKit


class PosterTableViewCell: UITableViewCell {

    private let posterImgView: UIImageView = {
        let imgView = UIImageView()
        imgView.contentMode = .scaleAspectFit
        return imgView
    }()

    private var heightConstraint: Constraint?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(posterImgView)
        setLayout()
        setupTheme()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setLayout() {
        posterImgView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(10)
            heightConstraint = make.height.equalTo(0).constraint
        }
    }

    func configureCell(posterPath: String, ratio: Double, fixedWidth: CGFloat) {
        let imageResource = KF.ImageResource(downloadURL: URL(string: MovieUseCase.configureUrlString(imagePath: posterPath)!)!)
        posterImgView.kf.setImage(with: imageResource)
        let height = fixedWidth / CGFloat(ratio)
        heightConstraint?.update(offset: height)
    }
}


extension PosterTableViewCell:ThemeChangeDelegate {
    func setupTheme() {
        self.theme.backgroundColor = themeService.attribute {$0.backgroundColor}
    }
}
