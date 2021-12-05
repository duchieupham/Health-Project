import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:health_project/features/news/events/cat_news_event.dart';
import 'package:health_project/features/news/repositories/news_repository.dart';
import 'package:health_project/features/news/states/cat_news_state.dart';
import 'package:health_project/models/category_news_dto.dart';

class CategoryNewsBloc extends Bloc<CategoryNewsEvent, CategoryNewsState> {
  final NewsRepository repository;

  CategoryNewsBloc({required this.repository})
      : super(CategoryNewsInitialState());

  @override
  Stream<CategoryNewsState> mapEventToState(CategoryNewsEvent event) async* {
    if (event is CategoryNewsEventGet) {
      yield CategoryNewsLoadingState();
      try {
        //
        final List<CategoryNewsDTO> list =
            await repository.getListCategoryNews();
        yield CategoryNewsSuccessState(list: list);
      } catch (e) {
        yield CategoryNewsFailedState();
      }
    }
  }
}
