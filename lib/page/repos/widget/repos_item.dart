import 'package:flutter/material.dart';
import 'package:gsy_github_app_flutter/common/style/gsy_style.dart';
import 'package:gsy_github_app_flutter/common/utils/HexColor.dart';
import 'package:gsy_github_app_flutter/common/utils/common_utils.dart';
import 'package:gsy_github_app_flutter/common/utils/navigator_utils.dart';
import 'package:gsy_github_app_flutter/model/Repository.dart';
import 'package:gsy_github_app_flutter/model/RepositoryQL.dart';
import 'package:gsy_github_app_flutter/widget/gsy_card_item.dart';
import 'package:gsy_github_app_flutter/widget/gsy_icon_text.dart';
import 'package:gsy_github_app_flutter/widget/gsy_user_icon_widget.dart';
import 'package:supercharged/supercharged.dart';

/**
 * 仓库Item
 * Created by guoshuyu
 * Date: 2018-07-16
 */
class ReposItem extends StatelessWidget {
  final ReposViewModel reposViewModel;
  final int? index;
  final VoidCallback? onPressed;

  ReposItem(this.reposViewModel, {this.index = 0, this.onPressed}) : super();

  ///仓库item的底部状态，比如star数量等
  _getBottomItem(BuildContext context, IconData icon, String? text,
      {int flex = 3}) {
    Size ctxSize = MediaQuery.of(context).size;
    return new Expanded(
      flex: flex,
      child: new Center(
        child: new GSYIConText(
          icon,
          text,
          GSYConstant.smallSubText,
          GSYColors.subTextColor,
          15.0,
          padding: 2.0,
          textWidth:
              flex == 4 ? (ctxSize.width - 100) / 3 : (ctxSize.width - 100) / 4,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // print("index :: " + index!.toString());
    Color primaryColor = Theme.of(context).primaryColor;
    Size ctxSize = MediaQuery.of(context).size;
    return new Container(
      child: new GSYCardItem(
          margin: EdgeInsets.only(left: 15, right: 15, top: 5, bottom: 10),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(6),
                  topRight: Radius.circular(6),
                  bottomLeft: Radius.circular(6),
                  bottomRight: Radius.circular(6))),
          elevation: 5.0,
          color: Theme.of(context).primaryColorLight.tweenTo(Colors.white).lerp(GSYColors.cardFactor),
          child: new Container(
            margin: EdgeInsets.only(left: 5),
            padding: EdgeInsets.only(left: 5, right: 10, bottom: 3, top: 5),
            decoration: BoxDecoration(
              // color: index! % 2 == 0 ? Colors.lightBlue : Colors.lightGreen,
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
            // onPressed: onPressed,

            child: new Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                new Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ///头像

                      new GSYUserIconWidget(
                          width: 35.0,
                          height: 35.0,
                          image: reposViewModel.ownerPic,
                          onPressed: () {
                            NavigatorUtils.goPerson(
                                context, reposViewModel.ownerName);
                          }),

                      Container(
                        margin: EdgeInsets.only(right: 5),
                        // decoration: BoxDecoration(
                        //     color: index! % 2 == 0
                        //         ? Colors.transparent
                        //         : Colors.black12,
                        //     borderRadius: BorderRadius.circular(55),
                        //     boxShadow: [
                        //       BoxShadow(
                        //           color: Colors.grey.shade300,
                        //           blurRadius: 1,
                        //           spreadRadius: 3)
                        //     ]
                        // ),
                        // height: 100,
                        // width: ctxSize.width - 100.0,
                        child: new Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: <Widget>[
                            ///仓库名
                            Container(
                              // color: Colors.red,
                              width: ctxSize.width * 0.5,
                              alignment: Alignment.centerRight,
                              child: InkWell(
                                    child: new Text(
                                      reposViewModel.repositoryName ?? "",
                                      style: GSYConstant.normalTextBold.copyWith(color: GSYColors.primaryLightValue.tweenTo(Colors.white).lerp(0.8)),
                                      overflow: TextOverflow.ellipsis,
                                      textAlign: TextAlign.end,
                                      maxLines: 1,
                                    ),
                                    onTap: onPressed
                                  )
                            ),

                            ///用户名
                            new GSYIConText(
                                GSYICons.REPOS_ITEM_USER,
                                reposViewModel.ownerName,
                                GSYConstant.smallSubLightText,
                                GSYColors.subLightTextColor,
                                10.0,
                                padding: 3.0,
                                onPressed: onPressed,
                                mainAxisAlignment: MainAxisAlignment.center),
                          ],
                        ),
                      )
                    ]),
                SizedBox(height: 8),
                new Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ///仓库语言
                    reposViewModel.repositoryType!.isEmpty
                        ? Container()
                        : Container(
                            // color: Theme.of(context).shadowColor,
                            padding: EdgeInsets.only(
                                left: 5, right: 5, top: 2, bottom: 2),
                            decoration: BoxDecoration(
                              // color: index! % 2 == 0 ? Colors.lightBlue : Colors.lightGreen,
                              color: primaryColor.withOpacity(0.5),
                              borderRadius: BorderRadius.circular(10.0),
                              // boxShadow: [
                              //   BoxShadow(
                              //       color: Colors.grey.shade300,
                              //       blurRadius: 1,
                              //       spreadRadius: 3)
                              // ]
                            ),
                            child: new Text(
                                ":: " + reposViewModel.repositoryType!,
                                style: GSYConstant.minText
                                    .copyWith(color: Theme.of(context).primaryColorDark.tweenTo(Colors.white).lerp(0.5))))
                  ],
                ),
                new Container(

                    ///仓库描述
                    child: new Text(
                      reposViewModel.repositoryDes!,
                      style: GSYConstant.smallSubText,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                    margin: new EdgeInsets.only(top: 6.0, bottom: 2.0),
                    alignment: Alignment.topLeft),
                // new Padding(padding: EdgeInsets.only(bottom: 3.0)),
                new Padding(
                  padding: const EdgeInsets.only(
                      left: 5, right: 2, top: 5, bottom: 5),
                  child: Container(
                    height: 2,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(colors: [
                        primaryColor,
                        primaryColor.tweenTo(GSYColors.white).lerp(0.5)!.withOpacity(0.5),
                      ]),
                      // color: primaryColor.tweenTo(Colors.blueGrey).lerp(0.4),
                      borderRadius: BorderRadius.all(Radius.circular(4.0)),
                    ),
                  ),
                ),

                ///仓库状态数值
                new Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    _getBottomItem(context, GSYICons.REPOS_ITEM_STAR,
                        reposViewModel.repositoryStar),
                    _getBottomItem(context, GSYICons.REPOS_ITEM_FORK,
                        reposViewModel.repositoryFork),
                    _getBottomItem(context, GSYICons.REPOS_ITEM_ISSUE,
                        reposViewModel.repositoryWatch,
                        flex: 4),
                  ],
                ),
              ],
            ),
          )),
    );
  }
}

class ReposViewModel {
  String? ownerName;
  String? ownerPic;
  String? repositoryName;
  String? repositoryStar;
  String? repositoryFork;
  String? repositoryWatch;
  String? hideWatchIcon;
  String? repositoryType = "";
  String? repositoryDes;

  ReposViewModel();

  ReposViewModel.fromMap(Repository data) {
    ownerName = data.owner!.login;
    ownerPic = data.owner!.avatar_url;
    repositoryName = data.name;
    repositoryStar = data.watchersCount.toString();
    repositoryFork = data.forksCount.toString();
    repositoryWatch = data.openIssuesCount.toString();
    repositoryType = data.language ?? '---';
    repositoryDes = data.description ?? '---';
  }

  ReposViewModel.fromQL(RepositoryQL data) {
    ownerName = data.ownerName;
    ownerPic = data.ownerAvatarUrl;
    repositoryName = data.reposName;
    repositoryStar = data.starCount.toString();
    repositoryFork = data.forkCount.toString();
    repositoryWatch = data.watcherCount.toString();
    repositoryType = data.language ?? '---';
    repositoryDes =
        CommonUtils.removeTextTag(data.shortDescriptionHTML) ?? '---';
  }

  ReposViewModel.fromTrendMap(model) {
    ownerName = model.name;
    if (model.contributors != null && model.contributors.length > 0) {
      ownerPic = model.contributors[0];
    } else {
      ownerPic = "";
    }
    repositoryName = model.reposName;
    repositoryStar = model.starCount;
    repositoryFork = model.forkCount;
    repositoryWatch = model.meta;
    repositoryType = model.language;
    repositoryDes = CommonUtils.removeTextTag(model.description);
  }
}
