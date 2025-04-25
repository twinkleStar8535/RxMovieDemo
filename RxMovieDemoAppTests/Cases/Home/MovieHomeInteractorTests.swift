import XCTest
import RxSwift

@testable import RxMovieDemoApp

// MARK: - Mock

class MockMovieHomeWorker: MovieHomeWorkerProtocol {
    var mockNowPlayingResponse: Result<[MovieHomeListData], Error>!
    var mockPopularResponse: Result<[MovieHomeListData], Error>!
    var mockUpcomingResponse: Result<[MovieHomeListData], Error>!
    var mockTopRatedResponse: Result<[MovieHomeListData], Error>!
    
    func fetchNowPlaying() -> Observable<[MovieHomeListData]> {
        return Observable.create { [weak self] observer in
            guard let self = self else {
                observer.onError(ServerError.unknownError)
                return Disposables.create()
            }
            
            switch self.mockNowPlayingResponse {
            case .success(let movies):
                observer.onNext(movies)
                observer.onCompleted()
            case .failure(let error):
                observer.onError(error)
            case .none:
                observer.onError(ServerError.unknownError)
            }
            
            return Disposables.create()
        }
    }
    
    func fetchPopular() -> Observable<[MovieHomeListData]> {
        return Observable.create { [weak self] observer in
            guard let self = self else {
                observer.onError(ServerError.unknownError)
                return Disposables.create()
            }
            
            switch self.mockPopularResponse {
            case .success(let movies):
                observer.onNext(movies)
                observer.onCompleted()
            case .failure(let error):
                observer.onError(error)
            case .none:
                observer.onError(ServerError.unknownError)
            }
            
            return Disposables.create()
        }
    }
    
    func fetchUpcoming() -> Observable<[MovieHomeListData]> {
        return Observable.create { [weak self] observer in
            guard let self = self else {
                observer.onError(ServerError.unknownError)
                return Disposables.create()
            }
            
            switch self.mockUpcomingResponse {
            case .success(let movies):
                observer.onNext(movies)
                observer.onCompleted()
            case .failure(let error):
                observer.onError(error)
            case .none:
                observer.onError(ServerError.unknownError)
            }
            
            return Disposables.create()
        }
    }
    
    func fetchTopRated() -> Observable<[MovieHomeListData]> {
        return Observable.create { [weak self] observer in
            guard let self = self else {
                observer.onError(ServerError.unknownError)
                return Disposables.create()
            }
            
            switch self.mockTopRatedResponse {
            case .success(let movies):
                observer.onNext(movies)
                observer.onCompleted()
            case .failure(let error):
                observer.onError(error)
            case .none:
                observer.onError(ServerError.unknownError)
            }
            
            return Disposables.create()
        }
    }
}

class MockMovieHomePresenter: MovieHomePresentationLogic {
    var isLoadingCalled = false
    var presentedMovies: MovieHome.FetchMovies.Response?
    var errorMessage: String?
    var presentedMovieId: Int?
    
    func presentLoading(isLoading: Bool) {
        isLoadingCalled = true
    }
    
    func presentMovies(response: MovieHome.FetchMovies.Response) {
        presentedMovies = response
    }
    
    func presentError(message: String) {
        errorMessage = message
    }
    
    func presentSelectedMovie(response: MovieHome.SelectMovie.Response) {
        presentedMovieId = response.movieId
    }
}

// MARK: - Test
class MovieHomeInteractorTests: XCTestCase {
    
    var sut: MovieHomeInteractor!
    var mockPresenter: MockMovieHomePresenter!
    var mockWorker: MockMovieHomeWorker!
    var disposeBag = DisposeBag()
    
    override func setUp() {
        super.setUp()
        mockPresenter = MockMovieHomePresenter()
        mockWorker = MockMovieHomeWorker()
        sut = MovieHomeInteractor(movieHomeWorker: mockWorker)
        sut.presenter = mockPresenter
    }
    
    override func tearDown() {
        sut = nil
        mockPresenter = nil
        mockWorker = nil
        super.tearDown()
    }
    
    func test_fetchMovies_Success() {

        let nowPlayingMovies = [
            MovieHomeListData(id: 1, title: "Now Playing 1", backdrop_path: "backdrop1", poster_path: "poster1", vote_average: 8.5)
        ]
        let popularMovies = [
            MovieHomeListData(id: 2, title: "Popular 1", backdrop_path: "backdrop2", poster_path: "poster2", vote_average: 9.0)
        ]
        let upcomingMovies = [
            MovieHomeListData(id: 3, title: "Upcoming 1", backdrop_path: "backdrop3", poster_path: "poster3", vote_average: 7.5)
        ]
        let topRatedMovies = [
            MovieHomeListData(id: 4, title: "Top Rated 1", backdrop_path: "backdrop4", poster_path: "poster4", vote_average: 8.0)
        ]
        
        mockWorker.mockNowPlayingResponse = .success(nowPlayingMovies)
        mockWorker.mockPopularResponse = .success(popularMovies)
        mockWorker.mockUpcomingResponse = .success(upcomingMovies)
        mockWorker.mockTopRatedResponse = .success(topRatedMovies)
        
        sut.fetchMovies(request: MovieHome.FetchMovies.Request())
        
        XCTAssertTrue(mockPresenter.isLoadingCalled)
        XCTAssertEqual(mockPresenter.presentedMovies?.nowPlayingMovies, nowPlayingMovies)
        XCTAssertEqual(mockPresenter.presentedMovies?.popularMovies, popularMovies)
        XCTAssertEqual(mockPresenter.presentedMovies?.upcomingMovies, upcomingMovies)
        XCTAssertEqual(mockPresenter.presentedMovies?.topRatedMovies, topRatedMovies)
        XCTAssertNil(mockPresenter.presentedMovies?.error)
    }
    
    func test_fetchMovies_Error() {
        mockWorker.mockNowPlayingResponse = .failure(ServerError.invalidURL)
        
        sut.fetchMovies(request: MovieHome.FetchMovies.Request())
        
        XCTAssertTrue(mockPresenter.isLoadingCalled)
        XCTAssertEqual(mockPresenter.errorMessage, "Fetch Error")
    }
    
    
    func test_selectMovie() {
        let movieId = 123
        let request = MovieHome.SelectMovie.Request(movieId: movieId)
        
        sut.selectMovie(request: request)
        
        XCTAssertEqual(sut.selectedMovieId, movieId)
        XCTAssertEqual(mockPresenter.presentedMovieId, movieId)
    }
}


