import 'package:health_project/features/news/events/like_news_event.dart';
import 'package:health_project/features/news/states/like_news_state.dart';
import 'package:health_project/main.dart';
import 'package:rxdart/subjects.dart';

class LikeNewsBloc {
  var state = LikedNewsState(list: []);
  //
  final eventController = BehaviorSubject<LikedNewsEvent>();
  final stateController = BehaviorSubject<LikedNewsState>();

  LikeNewsBloc() {
    eventController.stream.listen((event) async {
      if (event is FetchLikedNewsEvent) {
        await newsRepository.getLikedNews(event.newsId).then((value) async {
          state = LikedNewsState(list: value);
        });
      } else if (event is LikeNewsEvent) {
        await newsRepository.likeNews(event.dto).then((check) async {
          if (check) {
            eventController.add(FetchLikedNewsEvent(newsId: event.dto.newsId));
          }
        });
      } else if (event is UnlikeNewsEvent) {
        await newsRepository.unlikeNews(event.dto).then((check) async {
          if (check) {
            eventController.add(FetchLikedNewsEvent(newsId: event.dto.newsId));
          }
        });
      }
      stateController.sink.add(state);
    });
  }

  //
  void dispose() {
    stateController.close();
    eventController.close();
  }
}
