import 'package:flutter/material.dart';
import 'package:health_project/commons/constants/numeral.dart';
import 'package:health_project/commons/constants/theme.dart';
import 'package:health_project/commons/utils/image_util.dart';
import 'package:health_project/commons/utils/time_util.dart';
import 'package:health_project/commons/widgets/header_widget.dart';
import 'package:health_project/features/news/blocs/news_bloc.dart';
import 'package:health_project/features/news/events/news_event.dart';
import 'package:health_project/features/news/states/news_state.dart';
import 'package:health_project/features/news/views/news_detail_view.dart';
import 'package:health_project/models/category_news_dto.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:health_project/models/thumbnail_news_dto.dart';
import 'package:health_project/services/news_page_provider.dart';
import 'package:health_project/services/scroll_provider.dart';
import 'package:provider/provider.dart';

class NewsListView extends StatefulWidget {
  final CategoryNewsDTO categoryDTO;

  const NewsListView({required this.categoryDTO});

  @override
  State<StatefulWidget> createState() =>
      _NewsListView(categoryDTO: categoryDTO);
}

class _NewsListView extends State<NewsListView> {
  //
  _NewsListView({required this.categoryDTO});
  //
  final CategoryNewsDTO categoryDTO;
  late final ThumbnailNewsBloc _thumbnailNewsBloc;
  late final NewsPageProvider _newsPageProvider;
  final List<ThumbnailNewsDTO> _listNews = [];
  late final ScrollController _scrollController;
  late double _maxScrollExtent;
  late double _currentScroll;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _thumbnailNewsBloc = BlocProvider.of(context);
    _newsPageProvider = Provider.of<NewsPageProvider>(context, listen: false);
    _getListNews();
    _scrollController.addListener(() {
      //show button back to top
      if (_scrollController.position.pixels >= 150) {
        Provider.of<ScrollProvider>(context, listen: false)
            .updateBackToTop(true);
      } else if (_scrollController.position.pixels < 150) {
        Provider.of<ScrollProvider>(context, listen: false)
            .updateBackToTop(false);
      }
      //pagging
      //get max scroll position
      _maxScrollExtent = _scrollController.position.maxScrollExtent;
      //get current scroll position
      _currentScroll = _scrollController.position.pixels;
      //check whether scroll controller scroll to end and list is end.
      if (_maxScrollExtent - _currentScroll == 0 &&
          !_newsPageProvider.hasListEnd) {
        _newsPageProvider.turnNextPage();
        _thumbnailNewsBloc.add(NewsEventGetThumbnail(
            categoryNewsId: categoryDTO.id,
            page: _newsPageProvider.currentPage));
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: Scaffold(
          body: RefreshIndicator(
            onRefresh: _getListNews,
            child: Stack(
              children: [
                CustomScrollView(
                  physics: AlwaysScrollableScrollPhysics(),
                  controller: _scrollController,
                  slivers: [
                    SliverAppBar(
                      automaticallyImplyLeading: false,
                      pinned: true,
                      collapsedHeight: MediaQuery.of(context).size.width * 0.3,
                      floating: false,
                      expandedHeight: MediaQuery.of(context).size.width * 0.7,
                      flexibleSpace: SliverHeader(
                        minHeight: MediaQuery.of(context).size.width * 0.3,
                        maxHeight: MediaQuery.of(context).size.width * 0.7,
                        typeName: categoryDTO.typeName,
                        image: categoryDTO.image,
                      ),
                    ),
                    SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          return _buildListNews(context);
                        },
                        childCount: 1,
                      ),
                    )
                  ],
                ),
                Positioned(
                  top: 50,
                  right: 10,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(15),
                    onTap: () {
                      Navigator.pop(context, categoryDTO.typeName);
                    },
                    child: Container(
                      width: 30,
                      height: 30,
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: DefaultTheme.BLACK_BUTTON.withOpacity(0.6),
                      ),
                      child: Image.asset('assets/images/ic-close-white.png'),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 30,
                  right: 10,
                  child: Consumer<ScrollProvider>(
                      builder: (context, scroll, child) {
                    return (scroll.backToTop)
                        ? InkWell(
                            onTap: () {
                              _backToTop();
                            },
                            borderRadius: BorderRadius.circular(12),
                            child: Container(
                              width: 40,
                              height: 40,
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                color: Theme.of(context)
                                    .hintColor
                                    .withOpacity(0.5),
                              ),
                              child: Image.asset(
                                  'assets/images/ic-back-to-top.png'),
                            ),
                          )
                        : Container();
                  }),
                ),
              ],
            ),
          ),
        ),
        onWillPop: () => new Future(() => false));
  }

  Future<void> _getListNews() async {
    _listNews.clear();
    _thumbnailNewsBloc.add(NewsEventGetThumbnail(
        categoryNewsId: categoryDTO.id, page: _newsPageProvider.currentPage));
  }

  _backToTop() {
    _scrollController.animateTo(0.0,
        duration: Duration(milliseconds: 500), curve: Curves.easeInOut);
  }

  _buildListNews(BuildContext context) {
    return BlocConsumer<ThumbnailNewsBloc, NewsState>(
      listener: (context, state) {
        if (state is ThumbnailNewsSuccessState) {
          //Because when list is on initial/refresh state, it's empty.
          //Check list whether is empty for reset pagging.
          if (_listNews.isEmpty) {
            _newsPageProvider.updateListEnd(false);
          }
          //add all item when list isn't end
          if (!_newsPageProvider.hasListEnd) _listNews.addAll(state.list);
          //update variable when list is end
          if (state.list.length < DefaultNumeral.ROW_LOADING) {
            _newsPageProvider.updateListEnd(true);
            //Make sure after end of page, user refresh and reload 1st page.
            _newsPageProvider.prevToFirstPage();
          }
        }
      },
      builder: (context, state) {
        return (_listNews.isNotEmpty)
            ? ListView.builder(
                shrinkWrap: true,
                padding: EdgeInsets.only(left: 10, right: 10),
                physics: NeverScrollableScrollPhysics(),
                itemCount: (_newsPageProvider.hasListEnd)
                    ? _listNews.length
                    : _listNews.length + 1,
                itemBuilder: (BuildContext context, int index) {
                  return InkWell(
                    onTap: () {
                      //
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => NewsDetailView(
                            catId: _listNews[index].catId,
                            newsId: _listNews[index].newsId,
                          ),
                        ),
                      );
                    },
                    child: (index == _listNews.length)
                        ? Image.asset(
                            'assets/images/loading-news.png',
                            width: MediaQuery.of(context).size.width,
                          )
                        : Container(
                            width: MediaQuery.of(context).size.width,
                            margin: EdgeInsets.only(bottom: 5, top: 10),
                            padding: EdgeInsets.only(
                                top: 10, bottom: 10, left: 10, right: 10),
                            decoration: BoxDecoration(
                              color: Theme.of(context).cardColor,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.4,
                                  height:
                                      MediaQuery.of(context).size.width * 0.3,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    image: DecorationImage(
                                      image: ImageUtil.instance.getImageNetWork(
                                          _listNews[index].image),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                Spacer(),
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.45,
                                  height:
                                      MediaQuery.of(context).size.width * 0.3,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        '${_listNews[index].title}',
                                        style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w500,
                                          fontFamily: 'NewYork',
                                          letterSpacing: 0.3,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 4,
                                      ),
                                      Spacer(),
                                      RichText(
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        textAlign: TextAlign.left,
                                        text: TextSpan(
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontFamily: 'NewYork',
                                          ),
                                          children: <InlineSpan>[
                                            TextSpan(
                                              text:
                                                  '${TimeUtil.instance.formatLastMinute(_listNews[index].lastMinute, _listNews[index].timeCreated)}\t',
                                              style: TextStyle(
                                                color: Theme.of(context)
                                                    .accentColor,
                                              ),
                                            ),
                                            WidgetSpan(
                                              child: Padding(
                                                padding:
                                                    EdgeInsets.only(left: 10),
                                              ),
                                            ),
                                            TextSpan(
                                              text: '${_listNews[index].actor}',
                                              style: TextStyle(
                                                color: Theme.of(context)
                                                    .indicatorColor,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                  );
                })
            : Container(
                width: MediaQuery.of(context).size.width,
                height: 200,
                child: Center(
                  child: Text(
                    'Chưa có bài viết nào',
                    style: TextStyle(color: DefaultTheme.GREY_TEXT),
                    textAlign: TextAlign.center,
                  ),
                ),
              );
      },
    );
  }
}
