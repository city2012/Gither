import 'package:flutter/material.dart';
import 'package:gsy_github_app_flutter/common/style/gsy_style.dart';
import 'package:gsy_github_app_flutter/widget/gsy_tabs.dart' as GSYTab;
import 'package:supercharged/supercharged.dart';

import '../common/localization/default_localizations.dart';

///支持顶部和顶部的TabBar控件
///配合AutomaticKeepAliveClientMixin可以keep住
class HomeTabBarWidget extends StatefulWidget {
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

  HomeTabBarWidget({
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
  _HomeTabBarState createState() => new _HomeTabBarState();
}

class _HomeTabBarState extends State<HomeTabBarWidget>
    with TickerProviderStateMixin {
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
    // print("_navigationPageChanged" + " :: _index" + _index.toString() + "-index" + index.toString());
    _index = index;
    _tabController!.animateTo(index,
        duration: Duration(milliseconds: 300), curve: Curves.slowMiddle);
    widget.onPageChanged?.call(index);
  }

  _navigationTapClick(index) {
    // print("_navigationTapClick"+ " :: _index-"+_index.toString()+".index-"+index.toString());
    if (_index == index) {
      return;
    }
    _index = index;
    widget.onPageChanged?.call(index);

    ///不想要动画
    // _pageController.jumpTo(MediaQuery.of(context).size.width * index);
    _pageController.animateTo(MediaQuery.of(context).size.width * index,
        duration: Duration(milliseconds: 300), curve: Curves.fastOutSlowIn);
    widget.onSinglePress?.call(index);
  }

  _navigationDoubleTapClick(index) {
    _navigationTapClick(index);
    widget.onDoublePress?.call(index);
  }

  @override
  Widget build(BuildContext context) {
    // List<Tab> tabList = widget.tabItems as List<Tab>;
    // print("Tab!--------"+tabList[0].text!);
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
                        GSYLocalizations.of(context)!
                            .currentLocalized!
                            .app_name,
                        style: GSYConstant.largeLargeTextWhite),
                    onPressed: () => Scaffold.of(context).openDrawer(),
                  )),
          leadingWidth: MediaQuery.of(context).size.width * 0.3,
        ),
        body: new PageView(
          controller: _pageController,
          children: widget.tabViews!,
          onPageChanged: (int newIndex) {
            setState(() {
              _navigationPageChanged(newIndex);
            });
          },
          allowImplicitScrolling: true,
        ),
        bottomNavigationBar: new Material(
          //为了适配主题风格，包一层Material实现风格套用
          // color: Theme.of(context).primaryColor, //底部导航栏主题颜色
          color: Theme.of(context).primaryColor, //底部导航栏主题颜色
          child: new SafeArea(
            maintainBottomViewPadding: true,
            child: Theme(
              data: ThemeData(
                brightness: Brightness.light,
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
              ),
              child: NavigationBarTheme(
                data: NavigationBarThemeData(
                  backgroundColor: Theme.of(context).primaryColor,
                  indicatorColor: Theme.of(context)
                      .primaryColorDark
                      .tweenTo(Colors.grey)
                      .lerp(0.2),
                  labelTextStyle: MaterialStateProperty.resolveWith(
                    (states) {
                      if (states.contains(MaterialState.focused) &&
                          !states.contains(MaterialState.pressed)) {
                        //获取焦点时的颜色
                        return TextStyle(color: Colors.red);
                      } else if (states.contains(MaterialState.selected)) {
                        //按下时的颜色
                        return TextStyle(color: Colors.white);
                      }
                      //默认状态使用灰色
                      return TextStyle(color: Colors.grey);
                    },
                  ),
                ),
                child: NavigationBar(
                  selectedIndex: _index,
                  onDestinationSelected: (int newIndex) {
                    setState(() {
                      _navigationTapClick(newIndex);
                    });
                    // _navigationDoubleTapClick(newIndex);
                  },
                  destinations: _buildNavigationList(context),
                ),
              ),
            ),

            // new GSYTab.TabBar(
            //   //TabBar导航标签，底部导航放到Scaffold的bottomNavigationBar中
            //   controller: _tabController,
            //   //配置控制器
            //   tabs: widget.tabItems!,
            //   indicatorColor: widget.indicatorColor,
            //   onDoubleTap: _navigationDoubleTapClick,
            //   onTap: _navigationTapClick, //tab标签的下划线颜色
            // ),
          ),
        ));
  }
}

List<NavigationDestination> _buildNavigationList(BuildContext context) {
  return [
    NavigationDestination(
        icon: Icon(GSYICons.MAIN_DT,
            color: Theme.of(context)
                .primaryColorDark
                .tweenTo(Colors.grey)
                .lerp(0.2)),
        label: GSYLocalizations.i18n(context)!.home_dynamic,
        selectedIcon: Icon(
          GSYICons.MAIN_DT,
          color: Colors.white,
          shadows: [Shadow(color: Colors.black, blurRadius: 1)],
        )),
    NavigationDestination(
        icon: Icon(GSYICons.MAIN_QS,
            color: Theme.of(context)
                .primaryColorDark
                .tweenTo(Colors.grey)
                .lerp(0.2)),
        label: GSYLocalizations.i18n(context)!.home_trend,
        selectedIcon: Icon(
          GSYICons.MAIN_QS,
          color: Colors.white,
          shadows: [Shadow(color: Colors.black, blurRadius: 1)],
        )),
    NavigationDestination(
        icon: Icon(GSYICons.MAIN_MY,
            color: Theme.of(context)
                .primaryColorDark
                .tweenTo(Colors.grey)
                .lerp(0.2)),
        label: GSYLocalizations.i18n(context)!.home_my,
        selectedIcon: Icon(
          GSYICons.MAIN_MY,
          color: Colors.white,
          shadows: [Shadow(color: Colors.black, blurRadius: 1)],
        )),
  ];
}

enum TabType { top, bottom }
