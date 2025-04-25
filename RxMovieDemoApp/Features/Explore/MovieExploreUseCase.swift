import Foundation
import RxSwift

protocol MovieExploreUseCaseProtocol {
    func fetchMovies(query: String?, filter: MovieExploreFilter?, page: Int) -> Observable<MovieExploreList>
}

class MovieExploreUseCase: MovieExploreUseCaseProtocol {
    private let worker: MovieExploreWorkerProtocol
    
    init(worker: MovieExploreWorkerProtocol = MovieExploreWorker()) {
        self.worker = worker
    }
    
    func fetchMovies(query: String?, filter: MovieExploreFilter?, page: Int) -> Observable<MovieExploreList> {
        return worker.fetchMovies(query: query, filter: filter, page: page)
    }
} 