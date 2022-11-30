import 'package:flutter/material.dart';
import 'package:gsy_github_app_flutter/common/style/gsy_style.dart';
import 'package:gsy_github_app_flutter/common/utils/common_utils.dart';
import 'package:gsy_github_app_flutter/common/utils/navigator_utils.dart';
import 'package:gsy_github_app_flutter/model/Repository.dart';
import 'package:gsy_github_app_flutter/model/RepositoryQL.dart';
import 'package:gsy_github_app_flutter/widget/gsy_card_item.dart';
import 'package:gsy_github_app_flutter/widget/gsy_icon_text.dart';
import 'package:gsy_github_app_flutter/widget/gsy_user_icon_widget.dart';

/**
 * 仓库Item
 * Created by guoshuyu
 * Date: 2018-07-16
 */
class ReposItem extends StatelessWidget {
  final ReposViewModel reposViewModel;
  final int? index;
  final VoidCallback? onPressed;

  ReposItem(this.reposViewModel, {this.index, this.onPressed}) : super();

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
          padding: 5.0,
          textWidth: flex == 4
              ? (ctxSize.width - 100) / 3
              : (ctxSize.width - 100) / 5,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    print("index :: " + index!.toString());
    return new Container(

      child: new GSYCardItem(
          margin: EdgeInsets.all(15),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          elevation: 8.0,

          child: new TextButton(

              onPressed: onPressed,
              child: new Padding(

                padding: new EdgeInsets.only(
                    left: 0.0, top: 10.0, right: 10.0, bottom: 10.0),
                child: new Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    new Row(
                      crossAxisAlignment: CrossAxisAlignment.start,

                      children: [
                        Container(
                            margin: EdgeInsets.only(left: 4),
                            decoration: BoxDecoration(
                              color: index! % 2 == 0 ?Colors.blueGrey : Colors.black12,
                              borderRadius: BorderRadius.circular(15),
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors.grey.shade300,
                                      blurRadius: 1,
                                      spreadRadius: 3
                                  )
                                ]
                            ),
                            height: 130,
                            width:300,
                            child: Column(
                                children: [
                                  ///头像
                                  new GSYUserIconWidget(
                                      padding: const EdgeInsets.only(
                                          top: 0.0, right: 0.0, left: 0.0),
                                      width: 40.0,
                                      height: 40.0,
                                      image: reposViewModel.ownerPic,
                                      onPressed: () {
                                        NavigatorUtils.goPerson(
                                            context, reposViewModel.ownerName);
                                      }),
                                  new Expanded(
                                    child: new Column(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: <Widget>[
                                        ///仓库名
                                        new Text(reposViewModel.repositoryName ?? "",
                                            style: GSYConstant.normalTextBold),

                                        ///用户名
                                        new GSYIConText(
                                          GSYICons.REPOS_ITEM_USER,
                                          reposViewModel.ownerName,
                                          GSYConstant.smallSubLightText,
                                          GSYColors.subLightTextColor,
                                          10.0,
                                          padding: 3.0,
                                            mainAxisAlignment: MainAxisAlignment.center
                                        ),
                                      ],
                                    ),
                                  ),

                                  ///仓库语言
                                  new Text(reposViewModel.repositoryType!,
                                      style: GSYConstant.smallSubText),

                                ]
                            )
                        )

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
                    new Padding(padding: EdgeInsets.all(10.0)),

                    ///仓库状态数值
                    new Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        _getBottomItem(context, GSYICons.REPOS_ITEM_STAR,
                            reposViewModel.repositoryStar),
                        new SizedBox(
                          width: 5,
                        ),
                        _getBottomItem(context, GSYICons.REPOS_ITEM_FORK,
                            reposViewModel.repositoryFork),
                        new SizedBox(
                          width: 5,
                        ),
                        _getBottomItem(context, GSYICons.REPOS_ITEM_ISSUE,
                            reposViewModel.repositoryWatch,
                            flex: 4),
                      ],
                    ),
                  ],
                ),
              ))),
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
