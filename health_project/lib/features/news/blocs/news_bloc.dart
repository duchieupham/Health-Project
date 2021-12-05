import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:health_project/commons/constants/numeral.dart';
import 'package:health_project/features/news/events/news_event.dart';
import 'package:health_project/features/news/repositories/news_repository.dart';
import 'package:health_project/features/news/states/news_state.dart';
import 'package:health_project/models/news_dto.dart';
import 'package:health_project/models/thumbnail_news_dto.dart';

class NewsBloc extends Bloc<NewsEvent, NewsState> {
  //
  final NewsRepository repository;

  NewsBloc({required this.repository}) : super(NewsDetailInitialState());

  @override
  Stream<NewsState> mapEventToState(NewsEvent event) async* {
    if (event is NewsEventGetDetail) {
      yield NewsDetailLoadingState();
      try {
        final NewsDetailDTO dto = await repository.getNewsDetail(event.newsId);
        if (dto.categoryType != 'n/a') {
          yield NewsDetailSuccessState(dto: dto);
        } else {
          yield NewsDetailFailedState();
        }
      } catch (e) {
        yield NewsDetailFailedState();
      }
    }
  }
}

class ThumbnailNewsBloc extends Bloc<NewsEvent, NewsState> {
  final NewsRepository repository;

  ThumbnailNewsBloc({required this.repository})
      : super(ThumbnailNewsInitialState());

  @override
  Stream<NewsState> mapEventToState(NewsEvent event) async* {
    if (event is NewsEventGetThumbnail) {
      yield ThumbnailNewsLoadingState();
      try {
        final List<ThumbnailNewsDTO> list = await repository.getNewsByCatId(
            event.categoryNewsId, event.page, DefaultNumeral.ROW_LOADING);
        yield ThumbnailNewsSuccessState(list: list);
      } catch (e) {
        yield ThumbnailNewsFailedState();
      }
    }
  }
}

class LastestNewsBloc extends Bloc<NewsEvent, NewsState> {
  final NewsRepository repository;
  LastestNewsBloc({required this.repository}) : super(LastedNewsInitialState());

  @override
  Stream<NewsState> mapEventToState(NewsEvent event) async* {
    if (event is NewsEventFetch) {
      try {
        final List<ThumbnailNewsDTO>? list = await repository.getListNews(
            event.page, DefaultNumeral.ROW_LOADING);
        if (list!.isNotEmpty) yield LastedNewsSuccessState(list: list);
      } catch (e) {
        print('ERROR at LastestNewsBloc: $e');
        yield LastedNewsFailedState();
      }
    }
  }
}

class RelatedNewsBloc extends Bloc<NewsEvent, NewsState> {
  final NewsRepository repository;
  RelatedNewsBloc({required this.repository})
      : super(RelatedNewsInitialState());

  @override
  Stream<NewsState> mapEventToState(NewsEvent event) async* {
    if (event is NewsEventGetRelated) {
      yield RelatedNewsLoadingState();
      try {
        final List<ThumbnailNewsDTO>? list =
            await repository.getRelatedNews(event.catId, event.id);
        if (list!.isNotEmpty) yield RelatedNewsSuccessState(list: list);
      } catch (e) {
        print('ERROR at RelatedNewsBloc: $e');
        yield RelatedNewsFailedState();
      }
    }
  }
}
