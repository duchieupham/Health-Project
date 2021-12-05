import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:health_project/commons/constants/numeral.dart';
import 'package:health_project/commons/constants/theme.dart';
import 'package:health_project/commons/utils/time_util.dart';
import 'package:health_project/commons/widgets/header_widget.dart';
import 'package:health_project/features/health/blocs/health_bloc.dart';
import 'package:health_project/features/health/events/health_event.dart';
import 'package:health_project/features/health/states/health_state.dart';
import 'package:health_project/models/activitiy_dto.dart';
import 'package:health_project/services/authentication_helper.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ActivityView extends StatelessWidget {
  static bool _isInitial = true;
  static late final ActivityBloc _activityBloc;
  static List<ActivityDTO> _activityList = [];
  //decorations
  static double _contentWidth = 0;
  static final double _marginTree = 20;
  const ActivityView();

  void initialServices(BuildContext context) {
    if (_isInitial) {
      _activityBloc = BlocProvider.of(context);

      _activityBloc.add(ActivityEventGetList(
          accountId: AuthenticateHelper.instance.getAccountId()));
      _isInitial = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isInitial) {
      initialServices(context);
    }
    _contentWidth = MediaQuery.of(context).size.width - 80;
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Stack(
          children: [
            //
            Positioned(
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.width / 4 * 3,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/bg-activity.png'),
                  ),
                ),
                child: ClipRRect(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(
                      sigmaX: 25,
                      sigmaY: 25,
                    ),
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.width / 4 * 3,
                      decoration: BoxDecoration(
                        color: Theme.of(context)
                            .scaffoldBackgroundColor
                            .withOpacity(0.4),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            //line
            Positioned(
              left: 34.5,
              top: 155,
              child: Container(
                height: MediaQuery.of(context).size.height - 200,
                width: 0.5,
                color: DefaultTheme.GREY_LIGHT,
              ),
            ),
            //content
            Positioned(
              top: 150,
              child: Container(
                height: MediaQuery.of(context).size.height - 150,
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.only(left: 30, right: 20),
                child: BlocBuilder<ActivityBloc, HealthState>(
                  builder: (context, state) {
                    if (state is ActivityPGetListSuccessState) {
                      _activityList = state.list;
                    }
                    return (_activityList.isNotEmpty)
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              //index 0
                              _buildFirstIndex(
                                context,
                                _activityList[0],
                              ),
                              //other indexes),
                              Expanded(
                                child: ListView.builder(
                                  itemCount: _activityList.length,
                                  padding: EdgeInsets.only(top: 20),
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return (index > 0)
                                        ? _buildOtherIndexes(
                                            context, _activityList[index])
                                        : Container();
                                  },
                                ),
                              ),
                              Padding(padding: EdgeInsets.only(bottom: 50)),
                            ],
                          )
                        : Container();
                  },
                ),
              ),
            ),
            //header
            Positioned(
              top: 40,
              child: SubHeader(title: 'Hoạt động thể chất'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFirstIndex(BuildContext context, ActivityDTO dto) {
    return Column(
      children: [
        //date
        _buildDateWidget(context,
            'Hôm nay của ${AuthenticateHelper.instance.getFirstNameAndLastName()}'),
        //content
        Container(
          width: _contentWidth,
          height: 150,
          margin: EdgeInsets.only(left: _marginTree, top: 10),
          decoration: _activityDecorationBox(context),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _buildElementInFirstIndex(
                context,
                'assets/images/ic-step-count.png',
                'Bước chân',
                'bước',
                dto.step.toString(),
                DefaultTheme.PURPLE_NEON,
              ),
              _buildElementInFirstIndex(
                context,
                'assets/images/ic-meter.png',
                'Quảng đường',
                'm',
                dto.meter.toString(),
                DefaultTheme.SUCCESS_STATUS,
              ),
              _buildElementInFirstIndex(
                context,
                'assets/images/ic-kcal.png',
                'Năng lượng',
                'kcal',
                dto.calorie.toString(),
                DefaultTheme.ORANGE,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildOtherIndexes(BuildContext context, ActivityDTO dto) {
    return Column(
      children: [
        //date
        _buildDateWidget(
            context, TimeUtil.instance.formatDateActivity(dto.dateTime)),
        //content
        Container(
          width: _contentWidth,
          padding: EdgeInsets.only(top: 20, bottom: 20),
          margin: EdgeInsets.only(left: _marginTree, top: 10, bottom: 30),
          decoration: _activityDecorationBox(context),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Image.asset(
                'assets/images/ic-step-count.png',
                width: 30,
                height: 30,
              ),
              Text(
                dto.step.toString(),
                style: TextStyle(
                  fontSize: 15,
                  color: DefaultTheme.PURPLE_NEON,
                ),
              ),
              Image.asset(
                'assets/images/ic-meter.png',
                width: 30,
                height: 30,
              ),
              Text(
                dto.meter.toString(),
                style: TextStyle(
                  fontSize: 15,
                  color: DefaultTheme.SUCCESS_STATUS,
                ),
              ),
              Image.asset(
                'assets/images/ic-kcal.png',
                width: 30,
                height: 30,
              ),
              Text(
                dto.calorie.toString(),
                style: TextStyle(
                  fontSize: 15,
                  color: DefaultTheme.ORANGE,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildElementInFirstIndex(BuildContext context, String imageAsset,
      String title, String unit, String value, Color color) {
    return Row(
      children: [
        Padding(padding: EdgeInsets.only(left: 20)),
        Image.asset(
          imageAsset,
          width: 20,
          height: 20,
        ),
        Container(
          width: _contentWidth * 1 / 3,
          margin: EdgeInsets.only(left: 5),
          child: Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 15,
            ),
          ),
        ),
        Container(
          width: _contentWidth * 1 / 3,
          margin: EdgeInsets.only(left: 5),
          child: RichText(
            textAlign: TextAlign.left,
            text: TextSpan(
              style: TextStyle(
                fontSize: 15,
                color: Theme.of(context).hintColor,
              ),
              children: [
                TextSpan(
                  text: value,
                  style: TextStyle(
                    color: color,
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                TextSpan(
                  text: ' $unit',
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDateWidget(BuildContext context, String textDate) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: 10,
          height: 10,
          margin: EdgeInsets.only(right: _marginTree),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: DefaultTheme.NEON,
              width: 1,
            ),
            color: Theme.of(context).scaffoldBackgroundColor,
          ),
        ),
        Container(
          width: _contentWidth,
          child: Text(
            textDate,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  BoxDecoration _activityDecorationBox(BuildContext context) {
    return BoxDecoration(
      color: Theme.of(context).primaryColor.withOpacity(0.6),
      border: Border.all(
        color: DefaultTheme.GREY_LIGHT,
        width: 0.25,
      ),
      borderRadius: BorderRadius.circular(DefaultNumeral.DEFAULT_BORDER_RAD),
    );
  }
}
