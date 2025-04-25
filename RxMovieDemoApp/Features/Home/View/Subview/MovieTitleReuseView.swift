//
//  MovieTitleReuseView.swift
//  RxMovieApp
//
//  Created by YcLin on 2025/3/20.
//

import UIKit
import SnapKit
import RxTheme

class MovieTitleReuseView: UICollectionReusableView {
    static let reuseIdentifier = "MovieTitleReuseView"

    var titleLabel = UILabel()

    var title: String? {
      didSet {
        configure()
      }
    }

    override init(frame: CGRect) {
      super.init(frame: frame)
      configure()
    }

    required init?(coder: NSCoder) {
      fatalError()
    }

    private func configure(){
        addSubview(titleLabel)
        titleLabel.font = .systemFont(ofSize: 18, weight: .bold)
        titleLabel.text = title
        titleLabel.snp.makeConstraints { make in
            make.top.left.equalToSuperview().offset(10)
            make.bottom.right.equalToSuperview().offset(-10)
        }
    }

}

