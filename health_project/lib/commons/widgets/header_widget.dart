import 'package:flutter/material.dart';
import 'package:health_project/commons/constants/theme.dart';
import 'package:health_project/commons/utils/image_util.dart';

class SubHeader extends StatelessWidget {
  final String title;

  const SubHeader({Key? key, required this.title}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 10),
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.all(8),
      height: 80,
      alignment: Alignment.centerLeft,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Container(
            //  color: Colors.red,
            child: InkWell(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: Image.asset(
                'assets/images/ic-pop.png',
                fit: BoxFit.contain,
                height: 30,
                width: 30,
              ),
            ),
          ),
          Spacer(),
          Text(
            title,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
          Spacer(),
          Container(
            width: 30,
            height: 30,
          ),
        ],
      ),
    );
  }
}

class SliverHeader extends StatelessWidget {
  final double maxHeight;
  final double minHeight;
  final String typeName;
  final String image;

  const SliverHeader({
    Key? key,
    required this.maxHeight,
    required this.minHeight,
    required this.typeName,
    required this.image,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final double expandRatio = _calculateExpandRatio(constraints);
        final AlwaysStoppedAnimation<double> animation =
            AlwaysStoppedAnimation(expandRatio);
        return Stack(
          alignment: Alignment.center,
          fit: StackFit.expand,
          children: [
            _buildImage(context),
            _buildGradient(animation),
            _buildTitle(animation),
          ],
        );
      },
    );
  }

  double _calculateExpandRatio(BoxConstraints constraints) {
    var expandRatio =
        (constraints.maxHeight - minHeight) / (maxHeight - minHeight);
    if (expandRatio > 1.0) expandRatio = 1.0;
    if (expandRatio < 0.4) expandRatio = 0.0;
    return expandRatio;
  }

  Container _buildGradient(Animation<double> animation) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            DefaultTheme.BLACK.withOpacity(0.2),
            DefaultTheme.BLACK.withOpacity(0.7),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
    );
  }

  Widget _buildTitle(Animation<double> animation) {
    return Align(
      alignment: AlignmentTween(
              begin: Alignment.bottomCenter, end: Alignment.bottomLeft)
          .evaluate(animation),
      child: Container(
          alignment: AlignmentTween(
                  begin: Alignment.bottomCenter, end: Alignment.bottomLeft)
              .evaluate(animation),
          padding: EdgeInsets.only(left: 20, right: 20, bottom: 30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                alignment: AlignmentTween(
                        begin: Alignment.bottomCenter,
                        end: Alignment.bottomLeft)
                    .evaluate(animation),
                child: Text(
                  'Hôm nay ‣ Bản tin',
                  style: TextStyle(
                      fontSize:
                          Tween<double>(begin: 13, end: 16).evaluate(animation),
                      fontWeight: FontWeight.w500,
                      color: DefaultTheme.WHITE),
                ),
              ),
              Container(
                alignment: AlignmentTween(
                        begin: Alignment.bottomCenter,
                        end: Alignment.bottomLeft)
                    .evaluate(animation),
                child: Text(
                  '$typeName',
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: TextStyle(
                    fontFamily: 'NewYork',
                    color: DefaultTheme.WHITE,
                    fontSize:
                        Tween<double>(begin: 25, end: 35).evaluate(animation),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          )),
    );
  }

  _buildImage(BuildContext context) {
    return Hero(
      tag: typeName,
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: (MediaQuery.of(context).size.width - 20) / 1.2,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: ImageUtil.instance.getImageNetWork(image),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}

enum ButtonHeaderType {
  NONE,
  AVATAR,
  BACK_HOME,
}
