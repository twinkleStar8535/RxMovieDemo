//
//  FavoritesViewController.swift
//  RxMovieDemoApp
//
//  Created by YcLin on 2025/4/4.
//

import UIKit
import RxSwift
import RxCocoa
import RxRelay
import JGProgressHUD
import RxTheme


enum FavsSection: String, CaseIterable {
    case favsection = "Favs"
}

protocol MovieFavsDisplayLogic: AnyObject {
    func displayMovieFavorites(viewModel: FavoritesMovie.FavoritesModels.ViewModel)
    func presentError(message: String)
}

class FavoritesViewController: UIViewController {

    private let interactor: FavoritesInteractorProtocol
    private let presenter: FavoritesPresenterProtocol
    private let disposeBag = DisposeBag()
    private var favoriteDataSource: UICollectionViewDiffableDataSource<FavsSection, FavoriteItems>! = nil
    
    private lazy var backButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(backButtonAction), for: .touchUpInside)
        button.setImage(UIImage(systemName: "chevron.backward"), for: .normal)
        button.tintColor = .white
        return button
    }()
    
    private var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Favorite Movies"
        label.textAlignment = .center
        return label
    }()
    
    private let hud: JGProgressHUD = {
        let hud = JGProgressHUD()
        hud.textLabel.text = "Loading ..."
        hud.detailTextLabel.text = "Please Wait"
        return hud
    }()
    
    private lazy var movieCollectionView: UICollectionView = {
        let defaultSize = self.view.bounds.width / 2
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: defaultSize - 15, height: 180)
        layout.estimatedItemSize = .zero
        layout.minimumLineSpacing = 8
        layout.minimumInteritemSpacing = 10
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.backgroundColor = .systemBackground
        collectionView.contentInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        collectionView.register(FavoritesCollectionViewCell.self, forCellWithReuseIdentifier: "FavoritesCollectionViewCell")
        return collectionView
    }()
    
    init() {
        let presenter = FavoritesPresenter()
        let interactor = FavoritesInteractor(presenter: presenter)
        self.interactor = interactor
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
        presenter.viewController = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
   //     setupDataSource()
        interactor.fetchFavorites()
        setLayout()
        setupTheme()
    }
    
    
    private func setLayout() {
        self.view.addSubview(backButton)
        self.view.addSubview(titleLabel)
        self.view.addSubview(movieCollectionView)
        
        backButton.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide).offset(5)
            make.left.equalToSuperview().offset(10)
            make.width.height.equalTo(30)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide).offset(5)
            make.centerX.equalToSuperview()
            make.width.equalTo(150)
            make.height.equalTo(35)
        }
        
        movieCollectionView.snp.makeConstraints { make in
            make.top.equalTo(backButton.snp.bottom).offset(10)
            make.left.right.bottom.equalToSuperview()
        }
    }
    
    @objc private func backButtonAction() {
        self.dismiss(animated: true, completion: nil)
    }
    
//    func reloadScreen() {
//        DispatchQueue.main.async {
//            self.interactor.fetchFavorites()
//        }
//    }
}

extension FavoritesViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let item = favoriteDataSource.itemIdentifier(for: indexPath) else { return }
        let movieDetailsVC = MovieDetailsViewController(id: item.movieID, popType: .withoutNavPresent)
        movieDetailsVC.modalPresentationStyle = .fullScreen
   //     movieDetailsVC.loadingDelegate = self
        self.present(movieDetailsVC, animated: true)
    }
    
    func numberOfItemsInSection(_ section: FavsSection) -> Int {
        guard let dataSource = favoriteDataSource else { return 0 }
        let snapshot = dataSource.snapshot()
        return snapshot.itemIdentifiers(inSection: section).count
    }
}

extension FavoritesViewController: FavoritesCollectionViewCellDelegate {
    func didTapButton(in cell: UICollectionViewCell) {
        if let indexPath = movieCollectionView.indexPath(for: cell),
           let favCell = cell as? FavoritesCollectionViewCell,
           let item = favoriteDataSource.itemIdentifier(for: indexPath) {
            let contentID = item.movieID
            
            interactor.checkIfIsFavsMovie(id: contentID) { [weak self] result in
                guard let self = self else { return }
                
                DispatchQueue.main.async {
                    switch result {
                    case .success(let (isFavorite, favsID)):
                        if isFavorite {
                            self.interactor.deleteFavorite(id: favsID)
                            favCell.collectBtn.setStatus(status: false)
                        } else {
                            let postModel = PostFavoriteRecordModel(fields: FavoriteItems(
                                movieID: contentID,
                                movieName: item.movieName,
                                posterURL: item.posterURL))
                            self.interactor.addFavorite(item: postModel)
                            favCell.collectBtn.setStatus(status: true)
                        }
                        favCell.collectBtn.setStatus(status: !isFavorite)
                    case .failure(let error):
                        print(error.localizedDescription)
                    }
                }
            }
        }
    }
}

extension FavoritesViewController: MovieFavsDisplayLogic {
    
    func displayMovieFavorites(viewModel: FavoritesMovie.FavoritesModels.ViewModel) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            
            self.favoriteDataSource = UICollectionViewDiffableDataSource<FavsSection, FavoriteItems>(collectionView: self.movieCollectionView) { (collectionView, indexPath, item) -> UICollectionViewCell? in
                                
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FavoritesCollectionViewCell", for: indexPath) as? FavoritesCollectionViewCell else { return UICollectionViewCell() }
                cell.interactor = self.interactor
                cell.delegate = self
                cell.configureCell(item: GetFavoriteRecordModel(id: "", fields: item), id: "")
                cell.configFavStatus(isFavorite: true)
                return cell
            }
            
            var snapShot = NSDiffableDataSourceSnapshot<FavsSection,FavoriteItems>()
            snapShot.appendSections([.favsection])
            snapShot.appendItems(viewModel.favoriteItems)
            
            self.favoriteDataSource.apply(snapShot, animatingDifferences: true)
            self.movieCollectionView.reloadData()
        }
    }
    
    func presentError(message: String) {
        print("Favs VC Get error: \(message)")
    }
}

extension FavoritesViewController {
    func didChange(isLoading: Bool) {
        if isLoading {
            hud.show(in: self.view)
        } else {
            hud.dismiss()
        }
    }
    
    func showErrorMessage() {
        hud.textLabel.text = "Fetch Error"
        hud.indicatorView = JGProgressHUDErrorIndicatorView()
        hud.show(in: self.view)
        hud.dismiss(afterDelay: 3.0)
    }
}

extension FavoritesViewController: ThemeChangeDelegate {
    func setupTheme() {
        self.view.theme.backgroundColor = themeService.attribute { $0.backgroundColor }
        self.movieCollectionView.theme.backgroundColor = themeService.attribute { $0.backgroundColor }
        self.titleLabel.theme.textColor = themeService.attribute { $0.textColor }
        self.backButton.theme.tintColor = themeService.attribute { $0.backButtonColor }
    }
}

