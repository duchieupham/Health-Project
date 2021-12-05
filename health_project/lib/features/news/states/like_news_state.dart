import 'package:health_project/models/like_dto.dart';
import 'package:equatable/equatable.dart';

class LikedNewsState extends Equatable {
  final List<LikeDTO> list;
  const LikedNewsState({required this.list});
  @override
  List<Object> get props => [list];
}
