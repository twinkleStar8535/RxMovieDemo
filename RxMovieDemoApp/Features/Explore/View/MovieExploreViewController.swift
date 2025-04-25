//
//  MovieExploreViewController.swift
//  RxMovieDemoApp
//
//  Created by YcLin on 2025/4/11.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit
import MJRefresh

protocol MovieExploreDisplayLogic: AnyObject {
    func displayMovies(viewModel: MovieExplore.FetchMovies.ViewModel)
    func displaySelectedMovie(viewModel: MovieExplore.SelectMovie.ViewModel)
    func displayError(message: String)
    func displayLoading(isLoading: Bool)
}

protocol MovieExploreDelegate: AnyObject {
    var exploreText: Observable<String>? { get set }
    func setMovieExploreBar()
}

class MovieExploreViewController: UIViewController, MovieExploreDisplayLogic {

    var page:Int = 1
    private var interactor: MovieExploreBusinessLogic?
    private let disposeBag = DisposeBag()
    private let searchTextSubject = BehaviorSubject<String>(value: "")
    private lazy var movieExploreBar = MovieExploreSearchBar()

    private lazy var exploreResultView:UICollectionView = {
        let defaultSize = self.view.bounds.width / 2
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 5
        layout.sectionInset = UIEdgeInsets(top: 10, left: 5, bottom: 10, right: 5)
        layout.scrollDirection = .vertical
        layout.estimatedItemSize = .zero
        layout.itemSize = CGSize(width: defaultSize - 20, height: defaultSize + 40)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(MovieExploreCell.self, forCellWithReuseIdentifier: "MovieExploreCell")
        return collectionView
    }()

    private var exploreText:Observable<String>{
        return searchTextSubject
            .map{$0}
            .filter{$0.count >= 3}
            .debounce(.milliseconds(1500), scheduler: MainScheduler.instance)
    }

    private let noItemView :UIView = {
        let view = UIView()
        return view
    }()

    private let footer = MJRefreshAutoNormalFooter()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupInteractor()
        self.exploreResultView.rx.setDelegate(self).disposed(by: disposeBag)
        setLayout()
        setMovieExploreBar()
        setMovieExploreResult()
        doMoreExplore()
        setupTheme()
    }

    private func setupInteractor() {
        interactor = MovieExploreInteractor()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.view.setNeedsLayout()
        navigationController?.view.layoutIfNeeded()
    }

    private func setLayout(){
        self.view.addSubview(movieExploreBar)
        self.view.addSubview(exploreResultView)
        self.view.addSubview(noItemView)

        movieExploreBar.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.left.equalToSuperview().inset(8)
            make.right.equalTo(view.snp.right).offset(-7)
            make.height.equalTo(90)
        }

        exploreResultView.snp.makeConstraints { make in
            make.top.equalTo(movieExploreBar.snp.bottom)
            make.left.right.bottom.equalToSuperview()
        }

        noItemView.snp.makeConstraints { make in
            make.top.equalTo(movieExploreBar.snp.bottom)
            make.left.right.bottom.equalToSuperview()
        }
    }

    private func setMovieExploreBar(){
        movieExploreBar.searchBarStyle = .minimal
        movieExploreBar.placeholder = "Explore"
        movieExploreBar.delegate = self
        movieExploreBar.backgroundColor = .clear
        movieExploreBar.barTintColor = .white
        movieExploreBar.tintColor = UIColor.white
        self.navigationItem.titleView = movieExploreBar
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tapGesture)
    }

    private func setMovieExploreResult(){
        exploreText.subscribe(onNext: { [weak self] txt in
            guard let self = self else { return }
            self.page = 1
            self.interactor?.startExplore(keyword: txt, page: self.page)
        }).disposed(by: disposeBag)

        interactor?.exploreResult
            .bind(to: self.exploreResultView.rx.items) { (collectionView, row, element) -> UICollectionViewCell in
                let indexPath = IndexPath(row: row, section: 0)
                let imageURL = MovieUseCase.configureUrlString(imagePath: element.poster_path ?? "")
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieExploreCell", for: indexPath) as! MovieExploreCell
                cell.configCell(imgURL: imageURL ?? "", voteRate: element.vote_average ?? 0.0)
                return cell
            }
            .disposed(by: disposeBag)

        self.exploreResultView.rx.itemSelected.subscribe(onNext: { [weak self] indexPath in
            guard let self = self else { return }
            guard let exploreID = self.interactor?.exploreResult.value[indexPath.row].id else {return}
            let vc = MovieDetailsViewController(id: exploreID, popType: .withoutNavPresent)
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true)
        }).disposed(by: disposeBag)
    }

    private func doMoreExplore() {
        exploreResultView.mj_footer?.isHidden = self.interactor?.exploreResult.value.count ?? 0 <= 0 ? true : false
        self.exploreResultView.mj_footer = MJRefreshAutoNormalFooter(refreshingTarget: self, refreshingAction: #selector(footerRefresh))
    }

    @objc func footerRefresh(){
        self.page += 1
        self.exploreResultView.mj_footer?.isHidden = false

        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.interactor?.startExplore(keyword: self.movieExploreBar.text ?? "", page: self.page)
            self.exploreResultView.mj_footer?.endRefreshing()
        }
    }

    @objc private func dismissKeyboard() {
        self.view.endEditing(true)
    }

    func displayMovies(viewModel: MovieExplore.FetchMovies.ViewModel) {
        if viewModel.isLoadMore {
            self.interactor?.exploreResult.accept(self.interactor?.exploreResult.value ?? [] + viewModel.movies)
        } else {
            self.interactor?.exploreResult.accept(viewModel.movies)
        }
    }
    
    func displaySelectedMovie(viewModel: MovieExplore.SelectMovie.ViewModel) {
        let vc = MovieDetailsViewController(id: viewModel.movieId, popType: .withoutNavPresent)
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true)
    }
    
    func displayError(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    func displayLoading(isLoading: Bool) {
        if isLoading {
            // 顯示載入指示器
            exploreResultView.mj_footer?.beginRefreshing()
        } else {
            // 隱藏載入指示器
            exploreResultView.mj_footer?.endRefreshing()
        }
    }
}

extension MovieExploreViewController:UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return interactor?.exploreResult.value.count ?? 0
    }
}

extension MovieExploreViewController :UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            self.interactor?.clearExplore()
            searchTextSubject.onNext("")
            noItemView.isHidden = false
        } else {
            searchTextSubject.onNext(searchText)
            noItemView.isHidden = true
        }
    }
}

extension MovieExploreViewController:ThemeChangeDelegate {
    func setupTheme() {
        self.view.theme.backgroundColor = themeService.attribute {$0.backgroundColor}
        noItemView.theme.backgroundColor = themeService.attribute {$0.backgroundColor}
        self.exploreResultView.theme.backgroundColor = themeService.attribute {$0.backgroundColor}
    }
}
