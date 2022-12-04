import 'package:flutter/material.dart';
import 'package:gsy_github_app_flutter/common/localization/default_localizations.dart';
import 'package:gsy_github_app_flutter/model/Event.dart';
import 'package:gsy_github_app_flutter/common/style/gsy_style.dart';
import 'package:gsy_github_app_flutter/common/utils/common_utils.dart';
import 'package:gsy_github_app_flutter/common/utils/event_utils.dart';
import 'package:gsy_github_app_flutter/common/utils/navigator_utils.dart';
import 'package:gsy_github_app_flutter/model/RepoCommit.dart';
import 'package:gsy_github_app_flutter/widget/gsy_card_item.dart';
import 'package:gsy_github_app_flutter/widget/gsy_user_icon_widget.dart';
import 'package:gsy_github_app_flutter/model/Notification.dart' as Model;
import 'package:supercharged/supercharged.dart';

/**
 * 事件Item
 * Created by guoshuyu
 * Date: 2018-07-16
 */
class GSYEventItem extends StatelessWidget {
  final EventViewModel eventViewModel;

  final VoidCallback? onPressed;

  final bool needImage;

  GSYEventItem(this.eventViewModel, {this.onPressed, this.needImage = true})
      : super();

  @override
  Widget build(BuildContext context) {
    Widget des = (eventViewModel.actionDes == null ||
            eventViewModel.actionDes!.length == 0)
        ? new Container()
        : new Container(
            child: new Text(
              eventViewModel.actionDes!,
              style: GSYConstant.smallSubText,
              maxLines: 3,
            ),
            margin: new EdgeInsets.only(top: 6.0, bottom: 2.0),
            alignment: Alignment.topLeft);

    Widget userImage = (needImage)
        ? new GSYUserIconWidget(
            padding: const EdgeInsets.only(top: 0.0, right: 5.0, left: 0.0),
            width: 30.0,
            height: 30.0,
            image: eventViewModel.actionUserPic,
            onPressed: () {
              NavigatorUtils.goPerson(context, eventViewModel.actionUser);
            })
        : Container();
    return new Container(
      child: new GSYCardItem(
          margin: EdgeInsets.only(left: 15, right: 15, top: 10, bottom: 5),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(6),
                  topRight: Radius.circular(6),
                  bottomLeft: Radius.circular(6),
                  bottomRight: Radius.circular(6))),
          elevation: 5.0,
          color: Theme.of(context).primaryColorLight.tweenTo(Colors.white).lerp(GSYColors.cardFactor),
          // color: Theme.of(context).primaryColorDark,
          // margin: EdgeInsets.only(left: 10.0, top: 5.0, right: 10.0, bottom: 5.0),
          child: Container(
            margin: EdgeInsets.only(left: 5),
            padding: EdgeInsets.only(left: 5, right: 10, bottom: 3),
            decoration: BoxDecoration(

              color: Theme.of(context).primaryColorDark,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(6),
                  topRight: Radius.circular(6),
                  bottomLeft: Radius.circular(6),
                  bottomRight: Radius.circular(6)),
              // boxShadow: [
              //   BoxShadow(
              //       color: Colors.grey.shade300,
              //       blurRadius: 1,
              //       spreadRadius: 3)
              // ]
            ),
            child: new TextButton(
                onPressed: onPressed,
                child: new Padding(
                  padding: new EdgeInsets.only(
                      left: 0.0, top: 5.0, right: 0.0, bottom: 5.0),
                  child: new Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[

                      new Row(
                        children: <Widget>[
                          // 图片
                          userImage,
                          // 名字
                          new Expanded(
                              child: new Text(eventViewModel.actionUser!,
                                  style: GSYConstant.smallTextBold.copyWith(color: GSYColors.primaryLightValue.tweenTo(Colors.white).lerp(0.8)))),
                          // 执行时间
                          new Text(eventViewModel.actionTime,
                              style: GSYConstant.smallSubText.copyWith(color: GSYColors.primaryLightValue.tweenTo(Colors.white).lerp(0.8))),
                        ],
                      ),
                      // 目标
                      new Container(
                          child: new Text(eventViewModel.actionTarget!,
                              style: GSYConstant.smallTextBold.copyWith(color: GSYColors.primaryLightValue.tweenTo(Colors.white).lerp(0.8))),
                          margin: new EdgeInsets.only(top: 6.0, bottom: 2.0),
                          alignment: Alignment.topLeft),
                      // 描述
                      des,
                    ],
                  ),
                )
            ),
          )

    ),
    );
  }
}

class EventViewModel {
  String? actionUser;
  String? actionUserPic;
  String? actionDes;
  late String actionTime;
  String? actionTarget;

  EventViewModel.fromEventMap(Event event) {
    actionTime = CommonUtils.getNewsTimeStr(event.createdAt!);
    actionUser = event.actor!.login;
    actionUserPic = event.actor!.avatar_url;
    var other = EventUtils.getActionAndDes(event);
    actionDes = other["des"];
    actionTarget = other["actionStr"];
  }

  EventViewModel.fromCommitMap(RepoCommit eventMap) {
    actionTime = CommonUtils.getNewsTimeStr(eventMap.commit!.committer!.date!);
    actionUser = eventMap.commit!.committer!.name;
    actionDes = "sha:" + eventMap.sha!;
    actionTarget = eventMap.commit!.message;
  }

  EventViewModel.fromNotify(BuildContext context, Model.Notification eventMap) {
    actionTime = CommonUtils.getNewsTimeStr(eventMap.updateAt!);
    actionUser = eventMap.repository!.fullName;
    String? type = eventMap.subject!.type;
    String status = eventMap.unread!
        ? GSYLocalizations.i18n(context)!.notify_unread
        : GSYLocalizations.i18n(context)!.notify_readed;
    actionDes = eventMap.reason! +
        "${GSYLocalizations.i18n(context)!.notify_type}：$type，${GSYLocalizations.i18n(context)!.notify_status}：$status";
    actionTarget = eventMap.subject!.title;
  }
}
