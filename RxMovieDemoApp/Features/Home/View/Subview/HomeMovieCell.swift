//
//  HomeMovieCell.swift
//  RxMovieDemoApp
//
//  Created by YcLin on 2025/4/5.
//

import UIKit
import Kingfisher


class HomeMovieCell: UICollectionViewCell {

    static let reuseIdentifer = "HomeMovieCell"

    let moviePhotoView = UIImageView()
    var titleLabel:UILabel = {
        let lbl = UILabel()
        lbl.font = .boldSystemFont(ofSize: 20)
        lbl.textColor = .white
        return lbl
    }()

    var title: String? {
      didSet {
        configure()
      }
    }

    var photoURLString: String? {
      didSet {
        configure()
      }
    }


    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        moviePhotoView.translatesAutoresizingMaskIntoConstraints = false


        contentView.addSubview(moviePhotoView)
        contentView.addSubview(titleLabel)

        titleLabel.adjustsFontForContentSizeCategory = true
        if let title = title {
            titleLabel.text = title
        }

        moviePhotoView.layer.cornerRadius = 8
        moviePhotoView.clipsToBounds = true

        if let url = URL(string: photoURLString ?? "") {
            let imageSource = KF.ImageResource(downloadURL: url)
            moviePhotoView.kf.setImage(with: imageSource,placeholder: UIImage(named: "noImageYet"))
        }

        NSLayoutConstraint.activate([
            moviePhotoView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
            moviePhotoView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor),
            moviePhotoView.topAnchor.constraint(equalTo: self.contentView.topAnchor,constant: 2),
            moviePhotoView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor,constant: -2),


            titleLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor,constant: 10),
            titleLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor,constant: -2),
            titleLabel.heightAnchor.constraint(equalToConstant: 40)
        ])

    }


}
