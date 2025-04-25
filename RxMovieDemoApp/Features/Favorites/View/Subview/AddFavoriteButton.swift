//
//  AddFavoriteButton.swift
//  RxMovieDemoApp
//
//  Created by YcLin on 2025/4/4.
//


import UIKit
import RxSwift
import RxRelay


class AddFavoriteButton: UIButton {

    private let disposeBag = DisposeBag()
    private var interactor: FavoritesInteractorProtocol?

    init(interactor: FavoritesInteractorProtocol?) {
        self.interactor = interactor
        super.init(frame: .zero)
        setupButton()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func updateInteractor(_ interactor: FavoritesInteractorProtocol) {
        self.interactor = interactor
    }

    private func setupButton() {
        DispatchQueue.main.async {
            self.setImage(UIImage(systemName: "heart.fill"), for: .normal)
            self.tintColor = .red
        }
    }

    func setStatus(status: Bool) {
        DispatchQueue.main.async {
            if (status) {
                self.setImage(UIImage(systemName: "heart.fill"), for: .normal)
                self.tintColor = .red
            } else {
                self.setImage(UIImage(systemName: "heart"), for: .normal)
                self.tintColor = .white
            }
        }
    }

}

