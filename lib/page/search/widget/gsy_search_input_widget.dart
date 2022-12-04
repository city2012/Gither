import 'package:flutter/material.dart';
import 'package:gsy_github_app_flutter/common/localization/default_localizations.dart';
import 'package:gsy_github_app_flutter/common/style/gsy_style.dart';
import 'package:supercharged/supercharged.dart';
/**
 * 搜索输入框
 * Created by guoshuyu
 * Date: 2018-07-20
 */
class GSYSearchInputWidget extends StatelessWidget {
  final TextEditingController? controller;

  final ValueChanged<String>? onSubmitted;

  final VoidCallback? onSubmitPressed;

  GSYSearchInputWidget(
      {this.controller, this.onSubmitted, this.onSubmitPressed});

  @override
  Widget build(BuildContext context) {
    return new Container(
      height: kToolbarHeight*0.7,
      width: MediaQuery.of(context).size.width*0.65,
      alignment: Alignment.centerLeft,

      decoration: new BoxDecoration(
          borderRadius: BorderRadius.horizontal(left: Radius.circular(40.0)),
          color: Colors.white.tweenTo(Theme.of(context).primaryColorDark).lerp(0.4),
          border:
              new Border.all(
                // color: Theme.of(context).primaryColor,
                color: Theme.of(context).primaryColorDark,
                width: 1.0, ),
          boxShadow: [
            BoxShadow(
                color: Theme.of(context).primaryColorDark, blurRadius: 4.0)
          ]),
      padding:
          new EdgeInsets.only(left: 20.0, top: 5.0, right: 20.0, bottom: 5.0),
      child: new Row(
        children: <Widget>[
          new Expanded(
              child: new TextField(
                  autofocus: false,
                  controller: controller,
                  decoration: new InputDecoration(
                    hintText: GSYLocalizations.i18n(context)!.repos_issue_search,
                    hintStyle: GSYConstant.middleSubText.copyWith(fontSize: 13.5),
                    border: InputBorder.none,
                    isDense: true,
                  ),
                  style: GSYConstant.middleText
                      .copyWith(textBaseline: TextBaseline.alphabetic),
                  onSubmitted: onSubmitted
              )
          ),
          new RawMaterialButton(
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              padding: const EdgeInsets.only(right: 5.0, left: 10.0),
              constraints: const BoxConstraints(minWidth: 0.0, minHeight: 0.0),
              child: new Icon(
                GSYICons.SEARCH,
                size: 15.0,
                color: Theme.of(context).primaryColorDark,
              ),
              onPressed: onSubmitPressed)
        ],
      ),
    );
  }
}
