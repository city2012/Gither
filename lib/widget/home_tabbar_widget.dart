import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:gsy_github_app_flutter/common/style/gsy_style.dart';
import 'package:gsy_github_app_flutter/widget/gsy_tabs.dart' as GSYTab;
import 'package:supercharged/supercharged.dart';

import '../common/localization/default_localizations.dart';
import '../redux/gsy_state.dart';
import 'anima/animated_bottom_bar.dart';

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

  _navigationPageChanged(int index) {
    if (_index == index) {
      return;
    }
    // print("_navigationPageChanged" + " :: _index" + _index.toString() + "-index" + index.toString());
    _index = index;
    _tabController!.animateTo(index,
        duration: Duration(milliseconds: 300), curve: Curves.slowMiddle);
    widget.onPageChanged?.call(index);
  }

  _navigationTapClick(int index) {
    // print("_navigationTapClick"+ " :: _index-"+_index.toString()+".index-"+index.toString());
    if (_index == index) {
      widget.onDoublePress?.call(index);
      return;
    }
    _index = index;
    // widget.onPageChanged?.call(index);

    ///不想要动画
    // _pageController.jumpTo(MediaQuery.of(context).size.width * index);
    _pageController.animateTo(MediaQuery.of(context).size.width * index,
        duration: Duration(milliseconds: 300), curve: Curves.fastOutSlowIn);
  }

  _navigationDoubleTapClick(int index) {
    print("!------------_navigationDoubleTapClick" + index.toString());
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
          // backgroundColor: Colors.red,
          // foregroundColor: Colors.red,
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
    ThemeData themeData = StoreProvider.of<GSYState>(context).state.themeData!;
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
                        // style: GSYConstant.largeLargeTextWhite.copyWith(color: Colors.blueGrey.shade700)),
                        style: GSYConstant.largeLargeTextWhite.copyWith(color: GSYColors.primaryIntValue == themeData.primaryColor.value ? GSYColors.white : GSYColors.primaryValue)),
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
                child: AnimatedBottomBar(
                  barItems: _genItems(context),
                  animationDuration: const Duration(milliseconds: 150),
                  barStyle: BarStyle(fontSize: 14.0, iconSize: 22.0),
                  onBarTap: (newIndex) {
                    setState(() {
                      _navigationTapClick(newIndex);
                    });
                  },
                  // onBarDoubleTap: (newIndex) {
                  //   setState(() {
                  //     _navigationDoubleTapClick(newIndex);
                  //   });
                  // },
                  backgroundColor: Theme.of(context).primaryColor,
                )

                // BottomNavigationBar
                // child: BottomNavigationBarTheme(
                //   data: BottomNavigationBarThemeData(
                //         elevation: 8.0,
                //         backgroundColor: Theme.of(context).primaryColor,
                //         selectedIconTheme: IconThemeData(
                //           color: Theme.of(context).primaryColorDark.tweenTo(Colors.grey).lerp(0.2),
                //           shadows: [Shadow(color: Colors.redAccent, blurRadius: 5, offset: Offset(-1, -3))]
                //         ),
                //         // selectedLabelStyle: TextStyle(color: Colors.white),
                //         // unselectedLabelStyle: TextStyle(color: Colors.grey),
                //         selectedItemColor: Colors.white,
                //         unselectedItemColor: Colors.grey,
                //     landscapeLayout: BottomNavigationBarLandscapeLayout.spread
                //   ),
                //   child: BottomNavigationBar(
                //     currentIndex: _index,
                //     onTap: (int newIndex) {
                //       setState(() {
                //         _navigationTapClick(newIndex);
                //       });
                //       // _navigationDoubleTapClick(newIndex);
                //     },
                //     items: _buildBottomNavigationList(context),
                //     elevation: 8.0,
                //     type: BottomNavigationBarType.fixed,
                //   ),
                // ),

                // NavigationBar
                // child: NavigationBarTheme(
                //   data: NavigationBarThemeData(
                //     elevation: 8.0,
                //     backgroundColor: Theme.of(context).primaryColor,
                //     indicatorColor: Theme.of(context)
                //         .primaryColorDark
                //         .tweenTo(Colors.grey)
                //         .lerp(0.2),
                //     labelTextStyle: MaterialStateProperty.resolveWith(
                //       (states) {
                //         if (states.contains(MaterialState.focused) &&
                //             !states.contains(MaterialState.pressed)) {
                //           //获取焦点时的颜色
                //           return TextStyle(color: Colors.red);
                //         } else if (states.contains(MaterialState.selected)) {
                //           //按下时的颜色
                //           return TextStyle(color: Colors.white);
                //         }
                //         //默认状态使用灰色
                //         return TextStyle(color: Colors.grey);
                //       },
                //     ),
                //   ),
                //   child: NavigationBar(
                //     selectedIndex: _index,
                //     onDestinationSelected: (int newIndex) {
                //
                //       setState(() {
                //         _navigationTapClick(newIndex);
                //       });
                //       // _navigationDoubleTapClick(newIndex);
                //     },
                //     destinations: _buildNavigationList(context),
                //   ),
                // ),
                ),
          ),
        ));
  }

  List<BarItem> _genItems(BuildContext context){
    GSYState gsyState = StoreProvider.of<GSYState>(context).state;
    return [
      BarItem(
        text: "Home",
        iconData: Icons.home_outlined,
        iconDataSelected: Icons.home_rounded,
        color: gsyState.isDark()?Colors.indigo.tweenTo(Colors.white).lerp(0.5):Colors.indigo,
        // color: Colors.white,
      ),
      // BarItem(
      //   text: "Likes",
      //   iconData: Icons.favorite_border,
      //   color: Colors.pinkAccent,
      // ),
      BarItem(
        // text: "Search",
        // iconData: Icons.search,
        // iconDataSelected: Icons.search_rounded,
        text: "Trend",
        iconData: Icons.trending_up_outlined,
        iconDataSelected: Icons.trending_up_rounded,
        // color: Colors.yellow.shade900,
        color: gsyState.isDark()?Colors.yellow.shade900.tweenTo(Colors.white).lerp(0.5):Colors.yellow.shade900,
      ),
      BarItem(
        text: "Profile",
        iconData: Icons.person_outline,
        iconDataSelected: Icons.person_rounded,
        // color: Colors.teal,
        color: gsyState.isDark()?Colors.teal.tweenTo(Colors.white).lerp(0.5):Colors.teal,
      ),
    ];
  }
  final List<BarItem> barItems = [
    BarItem(
      text: "Home",
      iconData: Icons.home_outlined,
      iconDataSelected: Icons.home_rounded,
      color: Colors.indigo.tweenTo(Colors.white).lerp(0.5),
      // color: Colors.white,
    ),
    // BarItem(
    //   text: "Likes",
    //   iconData: Icons.favorite_border,
    //   color: Colors.pinkAccent,
    // ),
    BarItem(
      // text: "Search",
      // iconData: Icons.search,
      // iconDataSelected: Icons.search_rounded,
      text: "Trend",
      iconData: Icons.trending_up_outlined,
      iconDataSelected: Icons.trending_up_rounded,
      // color: Colors.yellow.shade900,
      color: Colors.yellow.shade900.tweenTo(Colors.white).lerp(0.5),
    ),
    BarItem(
      text: "Profile",
      iconData: Icons.person_outline,
      iconDataSelected: Icons.person_rounded,
      // color: Colors.teal,
      color: Colors.teal.tweenTo(Colors.white).lerp(0.5),
    ),
  ];

  List<BottomNavigationBarItem> _buildBottomNavigationList(
      BuildContext context) {
    return [
      BottomNavigationBarItem(
          icon: Icon(GSYICons.MAIN_DT,
              color: Theme.of(context)
                  .primaryColorDark
                  .tweenTo(Colors.grey)
                  .lerp(0.2)),
          label: GSYLocalizations.i18n(context)!.home_dynamic,
          activeIcon: Icon(
            GSYICons.MAIN_DT,
            color: Colors.white,
            shadows: [Shadow(color: Colors.black, blurRadius: 1)],
          )),
      BottomNavigationBarItem(
          icon: Icon(GSYICons.MAIN_QS,
              color: Theme.of(context)
                  .primaryColorDark
                  .tweenTo(Colors.grey)
                  .lerp(0.2)),
          label: GSYLocalizations.i18n(context)!.home_trend,
          activeIcon: Icon(
            GSYICons.MAIN_QS,
            color: Colors.white,
            shadows: [Shadow(color: Colors.black, blurRadius: 1)],
          )),
      BottomNavigationBarItem(
          icon: Icon(GSYICons.MAIN_MY,
              color: Theme.of(context)
                  .primaryColorDark
                  .tweenTo(Colors.grey)
                  .lerp(0.2)),
          label: GSYLocalizations.i18n(context)!.home_my,
          activeIcon: Icon(
            GSYICons.MAIN_MY,
            color: Colors.white,
            shadows: [Shadow(color: Colors.black, blurRadius: 1)],
          )),
    ];
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
}

enum TabType { top, bottom }
