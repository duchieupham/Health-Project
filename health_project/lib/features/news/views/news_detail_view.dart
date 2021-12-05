import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:health_project/commons/constants/theme.dart';
import 'package:health_project/commons/utils/image_util.dart';
import 'package:health_project/commons/utils/time_util.dart';
import 'package:health_project/features/news/blocs/like_news_bloc.dart';
import 'package:health_project/features/news/blocs/news_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:health_project/features/news/events/like_news_event.dart';
import 'package:health_project/features/news/events/news_event.dart';
import 'package:health_project/features/news/states/like_news_state.dart';
import 'package:health_project/features/news/states/news_state.dart';
import 'package:health_project/models/like_action_dto.dart';
import 'package:health_project/models/like_dto.dart';
import 'package:health_project/services/authentication_helper.dart';
import 'package:health_project/services/scroll_provider.dart';
import 'package:health_project/services/theme_provider.dart';
import 'package:provider/provider.dart';

class NewsDetailView extends StatefulWidget {
  final int catId;
  final int newsId;

  const NewsDetailView({required this.catId, required this.newsId});

  @override
  State<StatefulWidget> createState() => _NewsDetailView(catId, newsId);
}

class _NewsDetailView extends State<NewsDetailView> {
  //variables
  static const double _sensitivePixel = 200;
  final int _newsId;
  final int _catId;
  String _typeName = '';
  double _position = 0;

  //blocs
  late final NewsBloc _newsBloc;
  late final RelatedNewsBloc _relatedNewsBloc;
  final LikeNewsBloc _likeNewsBloc = LikeNewsBloc();
  final _scrollController = ScrollController();
  late final ScrollProvider _scrollProvider;
  late ThemeProvider _themeProvider;

  //dto
  late LikeActionDTO _likeActionDTO;

  @override
  _NewsDetailView(this._catId, this._newsId);

  @override
  void initState() {
    super.initState();
    _newsBloc = BlocProvider.of(context);
    _relatedNewsBloc = BlocProvider.of(context);
    _scrollProvider = Provider.of<ScrollProvider>(context, listen: false);
    _themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    _newsBloc.add(NewsEventGetDetail(newsId: _newsId));
    _likeNewsBloc.eventController.sink
        .add(FetchLikedNewsEvent(newsId: _newsId));
    _likeActionDTO = LikeActionDTO(
        accountId: AuthenticateHelper.instance.getAccountId(), newsId: _newsId);
    _relatedNewsBloc.add(NewsEventGetRelated(catId: _catId, id: _newsId));
    //
    _scrollController.addListener(() {
      if (_scrollController.position.userScrollDirection ==
              ScrollDirection.forward &&
          (_position - _scrollController.position.pixels >= _sensitivePixel)) {
        _position = _scrollController.position.pixels;
        _scrollProvider.updateToolHidden(false);
      }
      if (_scrollController.position.userScrollDirection ==
              ScrollDirection.reverse &&
          (_scrollController.position.pixels - _position >= _sensitivePixel)) {
        _position = _scrollController.position.pixels;
        _scrollProvider.updateToolHidden(true);
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _likeNewsBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0,
      ),
      body: Stack(
        alignment: Alignment.center,
        fit: StackFit.expand,
        children: [
          _buildBody(),
          _buildBottomBar(),
        ],
      ),
    );
  }

  _buildBottomBar() {
    // consumer for update scroll position
    return Consumer<ScrollProvider>(
      builder: (context, scroll, child) {
        //animated position for changing bottom bar.
        return AnimatedPositioned(
          curve: Curves.fastOutSlowIn,
          bottom: scroll.isToolHidden ? 0 : 30,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(scroll.isToolHidden ? 0 : 20),
              boxShadow: (scroll.isToolHidden)
                  ? null
                  : [
                      BoxShadow(
                        color: DefaultTheme.GREY_TEXT.withOpacity(0.2),
                        spreadRadius: 5,
                        blurRadius: 10,
                        offset: Offset(0, 0), // changes position of shadow
                      ),
                    ],
            ),
            child: ClipRRect(
              clipBehavior: Clip.antiAlias,
              borderRadius:
                  BorderRadius.circular((scroll.isToolHidden) ? 0 : 20),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 25, sigmaY: 25),
                child: Container(
                  width: scroll.isToolHidden
                      ? MediaQuery.of(context).size.width
                      : MediaQuery.of(context).size.width - 80,
                  height: scroll.isToolHidden ? 40 : 60,
                  decoration: BoxDecoration(
                    borderRadius:
                        scroll.isToolHidden ? null : BorderRadius.circular(20),
                    color: scroll.isToolHidden
                        ? Theme.of(context).cardColor.withOpacity(0.7)
                        : Theme.of(context).buttonColor.withOpacity(0.7),
                  ),
                  child: scroll.isToolHidden
                      ? Container(
                          padding: EdgeInsets.only(bottom: 15),
                          width: MediaQuery.of(context).size.width,
                          alignment: Alignment.center,
                          child: Text(
                            (_typeName != '')
                                ? 'Hôm nay ‣ Bản tin ‣ $_typeName'
                                : '',
                            style: TextStyle(
                              fontSize: 13,
                              color: Theme.of(context).accentColor,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        )
                      : Container(
                          width: MediaQuery.of(context).size.width,
                          padding: EdgeInsets.only(left: 20, right: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              InkWell(
                                borderRadius: BorderRadius.circular(25),
                                onTap: () {
                                  scroll.updateBackToTop(true);
                                  Navigator.of(context).pop();
                                },
                                child: SizedBox(
                                  width: 25,
                                  height: 25,
                                  child: Image.asset(
                                      'assets/images/ic-backward.png'),
                                ),
                              ),
                              Padding(padding: EdgeInsets.only(left: 20)),
                              // consumer for changing theme
                              InkWell(
                                onTap: () async {
                                  _themeProvider.updateTheme(
                                    (_themeProvider.themeSystem ==
                                            DefaultTheme.THEME_SYSTEM)
                                        ? DefaultTheme.THEME_DARK
                                        : (_themeProvider.themeSystem ==
                                                DefaultTheme.THEME_DARK)
                                            ? DefaultTheme.THEME_LIGHT
                                            : DefaultTheme.THEME_SYSTEM,
                                  );
                                },
                                child: SizedBox(
                                  width: 25,
                                  height: 25,
                                  child: Image.asset((_themeProvider
                                              .themeSystem ==
                                          DefaultTheme.THEME_SYSTEM)
                                      ? 'assets/images/ic-system-mode.png'
                                      : (_themeProvider.themeSystem ==
                                              DefaultTheme.THEME_LIGHT)
                                          ? 'assets/images/ic-light-mode.png'
                                          : 'assets/images/ic-dark-mode.png'),
                                ),
                              ),
                              Spacer(),
                              StreamBuilder(
                                stream: _likeNewsBloc.stateController.stream,
                                initialData: _likeNewsBloc.state,
                                builder: (context,
                                    AsyncSnapshot<LikedNewsState> snapshot) {
                                  bool _checkLiked = snapshot.data!.list
                                      .where((element) =>
                                          element.accountId ==
                                          AuthenticateHelper.instance
                                              .getAccountId())
                                      .isNotEmpty;

                                  return Container(
                                    margin: EdgeInsets.all(0),
                                    child: Row(
                                      children: [
                                        InkWell(
                                          onTap: () {
                                            if (snapshot.data!.list.length > 0)
                                              _buildLikedNews(
                                                  snapshot.data!.list);
                                          },
                                          child: Text(
                                            (snapshot.data!.list.length == 0)
                                                ? 'Thích bài viết'
                                                : '${snapshot.data!.list.length} lượt thích',
                                            textAlign: TextAlign.right,
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 1,
                                            style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 15,
                                            ),
                                          ),
                                        ),
                                        Padding(
                                            padding: EdgeInsets.only(left: 20)),
                                        (_checkLiked)
                                            ? InkWell(
                                                onTap: () async {
                                                  //unlike action
                                                  _likeNewsBloc
                                                      .eventController.sink
                                                      .add(UnlikeNewsEvent(
                                                          dto: _likeActionDTO));
                                                },
                                                child: SizedBox(
                                                  width: 25,
                                                  height: 25,
                                                  child: Image.asset(
                                                      'assets/images/ic-like.png'),
                                                ),
                                              )
                                            : InkWell(
                                                onTap: () async {
                                                  //like action
                                                  _likeNewsBloc
                                                      .eventController.sink
                                                      .add(LikeNewsEvent(
                                                          dto: _likeActionDTO));
                                                },
                                                child: SizedBox(
                                                  width: 25,
                                                  height: 25,
                                                  child: Image.asset(
                                                      'assets/images/ic-unlike.png'),
                                                ),
                                              ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                ),
              ),
            ),
          ),
          duration: Duration(milliseconds: 300),
        );
      },
    );
  }

  _buildBody() {
    return BlocBuilder<NewsBloc, NewsState>(
      builder: (context, state) {
        if (state is NewsDetailFailedState) {
          return Container(
            width: MediaQuery.of(context).size.width,
            height: 200,
            child: Center(
              child: Text(
                'Không thể tải nội dung tin.\nVui lòng kiểm tra lại kết nối mạng.',
                style: TextStyle(fontSize: 15),
                textAlign: TextAlign.center,
              ),
            ),
          );
        }
        if (state is NewsDetailSuccessState) {
          if (state.dto.categoryType != 'n/a') {
            _typeName = state.dto.categoryType;
            return ListView(
              padding: EdgeInsets.only(left: 20, right: 20, top: 20),
              controller: _scrollController,
              children: <Widget>[
                //header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: EdgeInsets.only(
                          left: 10, right: 10, bottom: 5, top: 5),
                      decoration: BoxDecoration(
                        color: DefaultTheme.RED_CALENDAR.withOpacity(0.8),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        state.dto.categoryType,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: DefaultTheme.WHITE,
                        ),
                      ),
                    ),
                    Text(
                      '${TimeUtil.instance.formatNewsDetailsTime(state.dto.timeCreate)}',
                      style: TextStyle(
                        fontSize: 13,
                        color: Theme.of(context).accentColor,
                      ),
                    ),
                  ],
                ),
                Padding(padding: EdgeInsets.only(bottom: 20)),
                //title
                Text(
                  state.dto.title,
                  style: TextStyle(
                    height: 1.25,
                    fontSize: 22,
                    letterSpacing: 0.3,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'NewYork',
                  ),
                ),
                //content
                _buildContent(state.dto.paragraphs, state.dto.images),
                Text(
                  'Theo ${state.dto.actor}',
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    color: DefaultTheme.RED_CALENDAR,
                    fontSize: 16,
                    fontStyle: FontStyle.italic,
                    fontFamily: 'NewYork',
                    letterSpacing: 0.4,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                //related news
                Padding(
                  padding: EdgeInsets.only(
                    bottom: 20,
                    top: 20,
                  ),
                  child: Text(
                    'Tin liên quan',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                _buildRelatedNews(),
                //
                Padding(padding: EdgeInsets.only(bottom: 50)),
              ],
            );
          }
        }
        return Container();
      },
    );
  }

  _buildRelatedNews() {
    return BlocBuilder<RelatedNewsBloc, NewsState>(
      builder: (context, state) {
        return (state is RelatedNewsSuccessState && state.list.isNotEmpty)
            ? ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: state.list.length,
                itemBuilder: (BuildContext context, int index) {
                  return InkWell(
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => NewsDetailView(
                            catId: state.list[index].catId,
                            newsId: state.list[index].newsId,
                          ),
                        ),
                      );
                    },
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width * 0.3,
                          height: MediaQuery.of(context).size.width * 0.2,
                          margin: EdgeInsets.only(bottom: 10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            image: DecorationImage(
                              image: ImageUtil.instance
                                  .getImageNetWork(state.list[index].image),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.7 - 60,
                          height: MediaQuery.of(context).size.width * 0.2,
                          margin: EdgeInsets.only(left: 20),
                          alignment: Alignment.center,
                          child: Text(
                            state.list[index].title,
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontFamily: 'NewYork',
                              letterSpacing: 0.3,
                              height: 1.25,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                })
            : Container();
      },
    );
  }

  _buildContent(String paragraphs, String images) {
    List<String> _listP = [];
    List<String> _listI = [];
    for (String paragraph in paragraphs.split('---')) {
      _listP.add(paragraph);
    }
    for (String image in images.split(';')) {
      _listI.add(image);
    }
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.only(top: 20),
      child: ListView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: _listP.length,
        itemBuilder: (context, index) {
          return Column(
            children: [
              Text(
                '${_listP[index]}',
                style: TextStyle(
                  fontFamily: 'NewYork',
                  fontSize: 15,
                  wordSpacing: 0.3,
                  letterSpacing: 0.1,
                  height: 1.5,
                  fontWeight: FontWeight.w400,
                ),
              ),
              (!_listI.asMap().containsKey(index))
                  ? Container()
                  : Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.width * (3 / 4),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        image: DecorationImage(
                          image:
                              ImageUtil.instance.getImageNetWork(_listI[index]),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
            ],
          );
        },
      ),
    );
  }

  _buildLikedNews(List<LikeDTO> listLiked) {
    return showModalBottomSheet(
      isScrollControlled: false,
      context: this.context,
      backgroundColor: DefaultTheme.TRANSPARENT,
      builder: (context) {
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
          child: Padding(
            padding: EdgeInsets.only(bottom: 5, left: 5, right: 5),
            child: Container(
              padding: EdgeInsets.only(
                left: 20,
                right: 20,
                top: 30,
                bottom: 20,
              ),
              width: MediaQuery.of(context).size.width - 10,
              height: MediaQuery.of(context).size.height * 0.6,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(33.33),
                color: Theme.of(context).buttonColor.withOpacity(0.95),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      // Padding(padding: EdgeInsets.only(left: 10)),
                      Text(
                        'Lượt thích bài viết',
                        style: TextStyle(
                          fontSize: 15,
                        ),
                      ),
                      Spacer(),
                      Text(
                        '${listLiked.length}',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.right,
                      ),
                      // Padding(padding: EdgeInsets.only(right: 10)),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 20, top: 10),
                    child: Divider(
                      color: DefaultTheme.GREY_TOP_TAB_BAR,
                      height: 1,
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      padding: EdgeInsets.all(0),
                      shrinkWrap: true,
                      itemCount: listLiked.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Container(
                          width: MediaQuery.of(context).size.width,
                          height: 40,
                          margin: EdgeInsets.only(bottom: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              (listLiked[index].avatar != '')
                                  ? Container(
                                      width: 40,
                                      height: 40,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(40),
                                        border: Border.all(
                                            width: 0.25,
                                            color: DefaultTheme.GREY_TEXT),
                                        image: DecorationImage(
                                          image: ImageUtil.instance
                                              .getImageNetWork(
                                                  listLiked[index].avatar),
                                        ),
                                      ),
                                    )
                                  : Container(
                                      width: 40,
                                      height: 40,
                                      child: ClipOval(
                                        child: Image.asset(
                                            'assets/images/avatar-default.jpg'),
                                      ),
                                    ),
                              Padding(padding: EdgeInsets.only(left: 20)),
                              Text('${listLiked[index].name}'),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
