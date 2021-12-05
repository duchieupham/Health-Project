import 'package:flutter/material.dart';
import 'package:health_project/commons/constants/base_api.dart';
import 'package:health_project/services/authentication_helper.dart';
// import 'package:cached_network_image/cached_network_image.dart';

class ImageUtil {
  const ImageUtil._privateConsrtructor();

  static final ImageUtil _instance = ImageUtil._privateConsrtructor();
  static ImageUtil get instance => _instance;

  //get image from server
  NetworkImage getImageNetWork(String uri) {
    return NetworkImage(
      '$BASE_URL_IMAGE/$uri',
      headers: {"Authorization": AuthenticateHelper.instance.getTokenAccount()},
      scale: 1.0,
    );
  }

  Map<String, String> getHeaderImage() {
    return {"Authorization": AuthenticateHelper.instance.getTokenAccount()};
  }

  String getImageUrl(String uri) {
    return '$BASE_URL_IMAGE/$uri';
  }

  // CachedNetworkImage getCachedImageNetwork(BuildContext context, String uri,
  //     Widget errorWidget, Widget imageBuilder) {
  //   return CachedNetworkImage(
  //     imageUrl: "http://via.placeholder.com/200x150",
  //     imageBuilder: (context, imageProvider) => Container(
  //       decoration: BoxDecoration(
  //         image: DecorationImage(
  //             image: imageProvider,
  //             fit: BoxFit.cover,
  //             colorFilter: ColorFilter.mode(Colors.red, BlendMode.colorBurn)),
  //       ),
  //     ),
  //     placeholder: (context, url) => CircularProgressIndicator(),
  //     errorWidget: (context, url, error) => Icon(Icons.error),
  //   );
  // }
}
