import 'dart:convert';
import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:health_project/commons/constants/base_api.dart';
import 'package:health_project/models/category_news_dto.dart';
import 'package:health_project/models/custom_http_res_dto.dart';
import 'package:health_project/models/like_action_dto.dart';
import 'package:health_project/models/like_dto.dart';
import 'package:health_project/models/news_dto.dart';
import 'package:health_project/models/thumbnail_news_dto.dart';
import 'package:health_project/services/authentication_helper.dart';
import 'package:http/http.dart' as http;

class NewsRepository extends BaseApiClient {
  final http.Client httpClient;
  const NewsRepository({required this.httpClient});

  Future<List<CategoryNewsDTO>> getListCategoryNews() async {
    final String url = '/category';
    Map<String, String> header = {
      'url': BASE_URL + url,
      'token': AuthenticateHelper.instance.getTokenAccount(),
    };
    List<CategoryNewsDTO> list = [];
    final CustomHttpResponse response =
        await compute(APIClient.getAPIWithIsolate, header);
    if (response.statusCode == 200) {
      list = await compute(parseToCategoryNewsDTO, response.body);
    }
    return list;
  }

  Future<List<ThumbnailNewsDTO>> getNewsByCatId(
      int categoryNewsId, int start, int row) async {
    final String url = '/news/thumbnail/$categoryNewsId/$start/$row';
    Map<String, String> header = {
      'url': BASE_URL + url,
      'token': AuthenticateHelper.instance.getTokenAccount(),
    };
    List<ThumbnailNewsDTO> list = [];
    final CustomHttpResponse response =
        await compute(APIClient.getAPIWithIsolate, header);
    if (response.statusCode == 200) {
      list = await compute(parseToThumbnailDTO, response.body);
    }
    return list;
  }

  Future<List<ThumbnailNewsDTO>> getListNews(int start, int row) async {
    final url = '/news/thumbnail/$start/$row';
    Map<String, String> header = {
      'url': BASE_URL + url,
      'token': AuthenticateHelper.instance.getTokenAccount(),
    };
    List<ThumbnailNewsDTO> list = [];
    final CustomHttpResponse response =
        await compute(APIClient.getAPIWithIsolate, header);
    if (response.statusCode == 200) {
      list = await compute(parseToThumbnailDTO, response.body);
    }
    return list;
  }

  Future<List<ThumbnailNewsDTO>> getRelatedNews(int catId, int id) async {
    final url = '/news/related/$catId/$id';
    Map<String, String> header = {
      'url': BASE_URL + url,
      'token': AuthenticateHelper.instance.getTokenAccount(),
    };
    List<ThumbnailNewsDTO> list = [];
    final CustomHttpResponse response =
        await compute(APIClient.getAPIWithIsolate, header);
    if (response.statusCode == 200) {
      list = await compute(parseToThumbnailDTO, response.body);
    }
    return list;
  }

  Future<NewsDetailDTO> getNewsDetail(int newsId) async {
    final String url = '/news/$newsId';
    NewsDetailDTO dto = NewsDetailDTO(
      newsId: 0,
      categoryId: 0,
      categoryType: 'n/a',
      title: 'n/a',
      paragraphs: 'n/a',
      images: 'n/a',
      actor: 'n/a',
      timeCreate: 'n/a',
    );
    final response = await getApi(url);
    if (response.statusCode == 200) {
      dto = NewsDetailDTO.fromJson(jsonDecode(response.body));
    }
    return dto;
  }

  Future<List<LikeDTO>> getLikedNews(int newsId) async {
    final String url = '/news/$newsId/liked';
    Map<String, String> header = {
      'url': BASE_URL + url,
      'token': AuthenticateHelper.instance.getTokenAccount(),
    };
    List<LikeDTO> list = [];
    final CustomHttpResponse response =
        await compute(APIClient.getAPIWithIsolate, header);
    if (response.statusCode == 200) {
      list = await compute(parseToLikeDTO, response.body);
    }
    return list;
  }

  Future<bool> likeNews(LikeActionDTO dto) async {
    final String url = '/news/like';
    bool check = false;
    final request = await postApi(url, dto.toJson());
    if (request.statusCode == 200) {
      check = true;
    }
    return check;
  }

  Future<bool> unlikeNews(LikeActionDTO dto) async {
    final String url = '/news/unlike';
    bool check = false;
    final request = await postApi(url, dto.toJson());
    if (request.statusCode == 200) {
      check = true;
    }
    return check;
  }

  //parse Json to CategoryNewsDTO
  static List<CategoryNewsDTO> parseToCategoryNewsDTO(String resBody) {
    final data = jsonDecode(resBody).cast<Map<String, dynamic>>();
    return data
        .map<CategoryNewsDTO>((json) => CategoryNewsDTO.fromJson(json))
        .toList();
  }

  //parse Json to ThumbnailNewsDTO
  static List<ThumbnailNewsDTO> parseToThumbnailDTO(String resBody) {
    final data = jsonDecode(resBody).cast<Map<String, dynamic>>();
    return data
        .map<ThumbnailNewsDTO>((json) => ThumbnailNewsDTO.fromJson(json))
        .toList();
  }

  //parse Json to LikeDTO
  static List<LikeDTO> parseToLikeDTO(String resBody) {
    final data = jsonDecode(resBody).cast<Map<String, dynamic>>();
    return data.map<LikeDTO>((json) => LikeDTO.fromJson(json)).toList();
  }
}
