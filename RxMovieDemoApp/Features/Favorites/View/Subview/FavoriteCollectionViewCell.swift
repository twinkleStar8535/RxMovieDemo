//
//  FavoritesCollectionViewCell.swift
//  RxMovieDemoApp
//
//  Created by YcLin on 2025/4/5.
//
import UIKit
import SnapKit
import Kingfisher
import RxSwift
import RxCocoa
import RxRelay

protocol FavoritesCollectionViewCellDelegate: AnyObject {
    func didTapButton(in cell: UICollectionViewCell)
}

class FavoritesCollectionViewCell: UICollectionViewCell {

    private let disposeBag = DisposeBag()
    var interactor: FavoritesInteractorProtocol? {
        didSet {
            if let interactor = interactor {
                collectBtn.updateInteractor(interactor)
            }
        }
    }
    
    private(set) lazy var collectBtn: AddFavoriteButton = {
        let button = AddFavoriteButton(interactor: nil)
        return button
    }()

    weak var delegate: FavoritesCollectionViewCellDelegate?
    var isFavorite = true
    var contentID: String = ""

    private let movieImgView:UIImageView = {
        let imgView = UIImageView()
        imgView.isUserInteractionEnabled = true
        imgView.contentMode = .scaleAspectFill
        imgView.clipsToBounds = true
        return imgView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setBind()
    }

    init(frame: CGRect, interactor: FavoritesInteractorProtocol) {
        self.interactor = interactor
        super.init(frame: frame)
        setupUI()
        setBind()
        collectBtn.updateInteractor(interactor)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        self.addSubview(movieImgView)
        movieImgView.layer.cornerRadius = 16
        movieImgView.clipsToBounds = true
        movieImgView.addSubview(collectBtn)
        
        movieImgView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
        }

        collectBtn.snp.makeConstraints { make in
            make.top.right.equalToSuperview().inset(10)
            make.width.equalToSuperview().multipliedBy(0.1)
            make.height.equalToSuperview().multipliedBy(0.1)
        }
    }

    func configureCell(item: GetFavoriteRecordModel, id: String) {
        self.contentID = id
        
        if let url = URL(string: item.fields.posterURL ?? "") {
            let imageResource = KF.ImageResource(downloadURL: url)
            movieImgView.kf.setImage(with: imageResource, placeholder: UIImage(named: "noImageYet"))
        }
    }

    func configFavStatus(isFavorite:Bool) {
        self.isFavorite = isFavorite
        collectBtn.setStatus(status: isFavorite)
    }

    func setBind() {
        collectBtn.rx.tap
            .throttle(.milliseconds(500), scheduler: MainScheduler.instance)
            .subscribe { _ in
                self.delegate?.didTapButton(in: self)
            }.disposed(by: self.disposeBag)
    }

}
