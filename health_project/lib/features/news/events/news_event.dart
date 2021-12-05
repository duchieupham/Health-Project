import 'package:equatable/equatable.dart';

class NewsEvent extends Equatable {
  const NewsEvent();
  @override
  List<Object> get props => [];
}

class NewsEventFetch extends NewsEvent {
  final int page;
  const NewsEventFetch({required this.page});
  @override
  List<Object> get props => [page];
}

class NewsEventGetThumbnail extends NewsEvent {
  final int categoryNewsId;
  final int page;
  const NewsEventGetThumbnail(
      {required this.categoryNewsId, required this.page});
  @override
  List<Object> get props => [categoryNewsId, page];
}

class NewsEventGetDetail extends NewsEvent {
  final int newsId;
  const NewsEventGetDetail({required this.newsId});

  @override
  List<Object> get props => [newsId];
}

class NewsEventGetRelated extends NewsEvent {
  final int catId;
  final int id;
  const NewsEventGetRelated({required this.catId, required this.id});

  @override
  List<Object> get props => [catId, id];
}
