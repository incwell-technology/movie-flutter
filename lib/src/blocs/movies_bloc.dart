import '../resources/repository.dart';
import 'package:rxdart/rxdart.dart';
import '../models/item_model.dart';

class MoviesBloc {
  final _repository = Repository();

  final _moviesFetcher1 = PublishSubject<ItemModel>();
  final _moviesFetcher2 = PublishSubject<ItemModel>();
  final _moviesFetcher3 = PublishSubject<ItemModel>();
  final _moviesFetcher4 = PublishSubject<ItemModel>();

  Observable<ItemModel> get allPopularMovies => _moviesFetcher1.stream;
  Observable<ItemModel> get allNowPlayingMovies => _moviesFetcher2.stream;
  Observable<ItemModel> get allTopRatedMovies => _moviesFetcher3.stream;
  Observable<ItemModel> get allUpComingMovies => _moviesFetcher4.stream;

  fetchAllPopularMovies() async {
    ItemModel itemModel1 = await _repository.fetchAllPopularMovies();
    _moviesFetcher1.sink.add(itemModel1);
  }

  fetchAllNowPlayingMovies() async {
    ItemModel itemModel2 = await _repository.fetchAllNowPlayingMovies();
    _moviesFetcher2.sink.add(itemModel2);
  }

  fetchAllTopRatedMovies() async {
    ItemModel itemModel3 = await _repository.fetchAllTopRatedMovies();
    _moviesFetcher3.sink.add(itemModel3);
  }

  fetchAllUpComingMovies() async {
    ItemModel itemModel4 = await _repository.fetchAllUpComingMovies();
    _moviesFetcher4.sink.add(itemModel4);
  }

  dispose() {
    _moviesFetcher1.close();
    _moviesFetcher2.close();
    _moviesFetcher3.close();
    _moviesFetcher4.close();
  }
}

final bloc = MoviesBloc();

