import 'package:health_project/models/like_action_dto.dart';
import 'package:equatable/equatable.dart';

abstract class LikedNewsEvent extends Equatable {
  const LikedNewsEvent();
  @override
  List<Object> get props => [];
}

class LikeNewsEvent extends LikedNewsEvent {
  final LikeActionDTO dto;
  const LikeNewsEvent({required this.dto});

  @override
  List<Object> get props => [dto];
}

class UnlikeNewsEvent extends LikedNewsEvent {
  final LikeActionDTO dto;
  const UnlikeNewsEvent({required this.dto});

  @override
  List<Object> get props => [];
}

class FetchLikedNewsEvent extends LikedNewsEvent {
  final int newsId;
  const FetchLikedNewsEvent({required this.newsId});

  @override
  List<Object> get props => [newsId];
}
