import 'package:flutter/material.dart';
import 'package:gsy_github_app_flutter/common/style/gsy_style.dart';
import 'package:gsy_github_app_flutter/widget/gsy_icon_text.dart';
import 'package:gsy_github_app_flutter/widget/gsy_tabs.dart' as GSYTab;

import '../common/localization/default_localizations.dart';
import '../common/utils/navigator_utils.dart';

///支持顶部和顶部的TabBar控件
///配合AutomaticKeepAliveClientMixin可以keep住
class GSYTabBarWidget extends StatefulWidget {
  final TabType type;

  final bool resizeToAvoidBottomPadding;

  final List<Widget>? tabItems;

  final List<Widget>? tabViews;

  final Color? backgroundColor;

  final Color? indicatorColor;

  final Widget? title;

  final Widget? drawer;

  final Widget? floatingActionButton;

  final FloatingActionButtonLocation? floatingActionButtonLocation;

  final Widget? bottomBar;

  final List<Widget>? footerButtons;

  final ValueChanged<int>? onPageChanged;
  final ValueChanged<int>? onDoublePress;
  final ValueChanged<int>? onSinglePress;

  GSYTabBarWidget({
    Key? super.key,
    this.type = TabType.top,
    this.tabItems,
    this.tabViews,
    this.backgroundColor,
    this.indicatorColor,
    this.title,
    this.drawer,
    this.bottomBar,
    this.onDoublePress,
    this.onSinglePress,
    this.floatingActionButtonLocation,
    this.floatingActionButton,
    this.resizeToAvoidBottomPadding = true,
    this.footerButtons,
    this.onPageChanged,
  });

  @override
  _GSYTabBarState createState() => new _GSYTabBarState();
}

class _GSYTabBarState extends State<GSYTabBarWidget>
    with SingleTickerProviderStateMixin {
  final PageController _pageController = PageController();

  TabController? _tabController;

  int _index = 0;

  @override
  void initState() {
    super.initState();
    _tabController =
        new TabController(vsync: this, length: widget.tabItems!.length);
  }

  ///整个页面dispose时，记得把控制器也dispose掉，释放内存
  @override
  void dispose() {
    _tabController!.dispose();
    super.dispose();
  }

  _navigationPageChanged(index) {
    if (_index == index) {
      return;
    }
    _index = index;
    _tabController!.animateTo(index);
    widget.onPageChanged?.call(index);
  }

  _navigationTapClick(index) {
    if (_index == index) {
      return;
    }
    _index = index;
    widget.onPageChanged?.call(index);

    ///不想要动画
    _pageController.jumpTo(MediaQuery.of(context).size.width * index);
    widget.onSinglePress?.call(index);
  }

  _navigationDoubleTapClick(index) {
    _navigationTapClick(index);
    widget.onDoublePress?.call(index);
  }

  @override
  Widget build(BuildContext context) {
    if (widget.type == TabType.top) {
      ///顶部tab bar
      return new Scaffold(
        resizeToAvoidBottomInset: widget.resizeToAvoidBottomPadding,
        floatingActionButton:
            SafeArea(child: widget.floatingActionButton ?? Container()),
        floatingActionButtonLocation: widget.floatingActionButtonLocation,
        persistentFooterButtons: widget.footerButtons,
        appBar: new AppBar(
          backgroundColor: Theme.of(context).primaryColor,
          // backgroundColor: Colors.white,
          title: widget.title,
          bottom: new TabBar(
              controller: _tabController,
              tabs: widget.tabItems!,
              indicatorColor: widget.indicatorColor,
              onTap: _navigationTapClick),
        ),
        body: new PageView(
          controller: _pageController,
          children: widget.tabViews!,
          onPageChanged: _navigationPageChanged,
        ),
        bottomNavigationBar: widget.bottomBar,
      );
    }

    // return new Scaffold(
    //
    //       body:  Column(
    //               children: [
    //                 Container(
    //                   color: Colors.redAccent,
    //                   child: Row(
    //                     children: [
    //                       SafeArea(child: SizedBox(child:widget.title?? Container(color: Colors.redAccent), width: MediaQuery.of(context).size.width,)),
    //                     ],
    //                   ),
    //                 ),
    //                 Expanded(
    //                     child: new PageView(
    //                       controller: _pageController,
    //                       children: widget.tabViews!,
    //                       onPageChanged: _navigationPageChanged,
    //                     ),
    //                 )
    //
    //               ],
    //             )
    // );
    ///底部tab bar
    return new Scaffold(
        drawer: widget.drawer,
        appBar: new AppBar(
            toolbarHeight: 75,
            backgroundColor: Theme.of(context).primaryColor,
            // backgroundColor: Theme.of(context).primaryColorDark.withOpacity(0.8),
            title: widget.title,
            titleTextStyle: GSYConstant.largeLargeTextWhite,
            leading: Builder(
              builder: (context) => TextButton(
                // icon: new Icon(Icons.settings),
                child: Text(
                    GSYLocalizations.of(context)!.currentLocalized!.app_name,
                    style: GSYConstant.largeLargeTextWhite
                ),
                onPressed: () => Scaffold.of(context).openDrawer(),
              )
            ),
          leadingWidth: MediaQuery.of(context).size.width * 0.3,
        ),
        body: new PageView(
          controller: _pageController,
          children: widget.tabViews!,
          onPageChanged: _navigationPageChanged,
          allowImplicitScrolling: true,

        ),
        bottomNavigationBar: new Material(
          //为了适配主题风格，包一层Material实现风格套用
          color: Theme.of(context).primaryColor, //底部导航栏主题颜色
          child: new SafeArea(
            maintainBottomViewPadding: true,
            child: new GSYTab.TabBar(
              //TabBar导航标签，底部导航放到Scaffold的bottomNavigationBar中
              controller: _tabController,
              //配置控制器
              tabs: widget.tabItems!,
              indicatorColor: widget.indicatorColor,
              onDoubleTap: _navigationDoubleTapClick,
              onTap: _navigationTapClick, //tab标签的下划线颜色
            ),
          ),
        )
    );
  }
}

enum TabType { top, bottom }
