import 'package:equatable/equatable.dart';
import 'package:health_project/models/category_news_dto.dart';

class CategoryNewsState extends Equatable {
  const CategoryNewsState();

  @override
  List<Object> get props => [];
}

class CategoryNewsInitialState extends CategoryNewsState {}

class CategoryNewsLoadingState extends CategoryNewsState {}

class CategoryNewsSuccessState extends CategoryNewsState {
  final List<CategoryNewsDTO> list;
  const CategoryNewsSuccessState({required this.list});
  @override
  List<Object> get props => [list];
}

class CategoryNewsFailedState extends CategoryNewsState {}
