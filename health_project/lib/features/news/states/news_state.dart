import 'package:equatable/equatable.dart';
import 'package:health_project/models/news_dto.dart';
import 'package:health_project/models/thumbnail_news_dto.dart';

class NewsState extends Equatable {
  const NewsState();
  @override
  List<Object> get props => [];
}

//
//list thumbnail news by category ID states
class ThumbnailNewsInitialState extends NewsState {}

class ThumbnailNewsLoadingState extends NewsState {}

class ThumbnailNewsSuccessState extends NewsState {
  final List<ThumbnailNewsDTO> list;
  const ThumbnailNewsSuccessState({required this.list});

  @override
  List<Object> get props => [list];
}

class ThumbnailNewsFailedState extends NewsState {}

//
// news detail states
class NewsDetailInitialState extends NewsState {}

class NewsDetailLoadingState extends NewsState {}

class NewsDetailSuccessState extends NewsState {
  final NewsDetailDTO dto;
  const NewsDetailSuccessState({required this.dto});

  @override
  List<Object> get props => [dto];
}

class NewsDetailFailedState extends NewsState {}

//
//load lasted news
class LastedNewsInitialState extends NewsState {}

class LastedNewsLoadingState extends NewsState {}

class LastedNewsSuccessState extends NewsState {
  final List<ThumbnailNewsDTO> list;
  const LastedNewsSuccessState({required this.list});

  @override
  List<Object> get props => [list];
}

class LastedNewsFailedState extends NewsState {}

//
//related news
class RelatedNewsInitialState extends NewsState {}

class RelatedNewsLoadingState extends NewsState {}

class RelatedNewsSuccessState extends NewsState {
  final List<ThumbnailNewsDTO> list;
  const RelatedNewsSuccessState({required this.list});

  @override
  List<Object> get props => [list];
}

class RelatedNewsFailedState extends NewsState {}
