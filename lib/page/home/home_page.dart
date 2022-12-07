import 'dart:async';
import 'dart:io';

import 'package:android_intent/android_intent.dart';
import 'package:flutter/material.dart';
import 'package:gsy_github_app_flutter/common/localization/default_localizations.dart';
import 'package:gsy_github_app_flutter/common/style/gsy_style.dart';
import 'package:gsy_github_app_flutter/common/utils/navigator_utils.dart';
import 'package:gsy_github_app_flutter/page/dynamic/dynamic_page.dart';
import 'package:gsy_github_app_flutter/page/my_page.dart';
import 'package:gsy_github_app_flutter/page/trend/trend_page.dart';
import 'package:gsy_github_app_flutter/widget/gsy_title_bar.dart';
import 'package:gsy_github_app_flutter/page/home/widget/home_drawer.dart';
import 'package:supercharged/supercharged.dart';

import '../../widget/home_tabbar_widget.dart';

/**
 * 主页
 * Created by guoshuyu
 * Date: 2018-07-16
 */
class HomePage extends StatefulWidget {
  static final String sName = "home";

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<DynamicPageState> dynamicKey = new GlobalKey();
  final GlobalKey<TrendPageState> trendKey = new GlobalKey();
  final GlobalKey<MyPageState> myKey = new GlobalKey();

  /// 不退出
  Future<bool> _dialogExitApp(BuildContext context) async {
    ///如果是 android 回到桌面
    if (Platform.isAndroid) {
      AndroidIntent intent = AndroidIntent(
        action: 'android.intent.action.MAIN',
        category: "android.intent.category.HOME",
      );
      await intent.launch();
    }

    return Future.value(false);
  }

  Tab _renderTab(icon, text) {
    return new Tab(
      child: new Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[new Icon(icon, size: 16.0), new Text(text)],
      ),
    );
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    List<Tab> tabs = [
      _renderTab(GSYICons.MAIN_DT, GSYLocalizations.i18n(context)!.home_dynamic),
      _renderTab(GSYICons.MAIN_QS, GSYLocalizations.i18n(context)!.home_trend),
      _renderTab(GSYICons.MAIN_MY, GSYLocalizations.i18n(context)!.home_my),
    ];

    ///增加返回按键监听
    return WillPopScope(
      onWillPop: () {
        return _dialogExitApp(context);
      },
      child: new HomeTabBarWidget(
        drawer: new HomeDrawer(),
        type: TabType.bottom,
        tabItems: tabs,
        tabViews: [
          new DynamicPage(key: dynamicKey),
          new TrendPage(key: trendKey),
          new MyPage(key: myKey),
        ],
        onDoublePress: (index) {
          switch (index) {
            case 0:
              dynamicKey.currentState!.scrollToTop();
              break;
            case 1:
              trendKey.currentState!.scrollToTop();
              break;
            case 2:
              myKey.currentState!.scrollToTop();
              break;
          }
        },
        indicatorColor: Theme.of(context).primaryColorDark.tweenTo(Colors.white).lerp(0.2),
        title: GSYTitleBar(
          "",
          // GSYLocalizations.of(context)!.currentLocalized!.app_name,
          iconData: GSYICons.MAIN_SEARCH,
          needRightLocalIcon: true,
          onRightIconPressed: (centerPosition) {
            NavigatorUtils.goSearchPage(context, centerPosition);
          }
        ),
      ),
    );
  }
}
