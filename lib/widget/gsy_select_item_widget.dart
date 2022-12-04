import 'package:flutter/material.dart';
import 'package:gsy_github_app_flutter/common/style/gsy_style.dart';
import 'package:gsy_github_app_flutter/widget/gsy_card_item.dart';

import '../common/localization/default_localizations.dart';

/**
 * 详情issue列表头部，PreferredSizeWidget
 * Created by guoshuyu
 * Date: 2018-07-19
 */

typedef void SelectTypeChanged<int>(int value);

class GSYSelectItemWidget extends StatefulWidget
    implements PreferredSizeWidget {
  final List<String> itemNames;

  final SelectTypeChanged? selectItemChanged;

  final RoundedRectangleBorder? shape;

  final double elevation;

  final double height;

  final EdgeInsets margin;

  GSYSelectItemWidget(this.itemNames, this.selectItemChanged,
      {this.elevation = 5.0,
      this.height = 70.0,
      this.shape,
      this.margin = const EdgeInsets.all(10.0)});

  @override
  _GSYSelectItemWidgetState createState() => _GSYSelectItemWidgetState();

  @override
  Size get preferredSize {
    return new Size.fromHeight(height);
  }
}

class _GSYSelectItemWidgetState extends State<GSYSelectItemWidget> {
  int selectIndex = 0;

  _GSYSelectItemWidgetState();

  _renderItem(BuildContext context, String name, int index) {
    var style = index == selectIndex
        ? GSYConstant.middleTextWhite
        : GSYConstant.middleSubLightText;
    return new Expanded(
      child: AnimatedSwitcher(
        transitionBuilder: (child, anim) {
          return ScaleTransition(child: child, scale: anim);
        },
        duration: Duration(milliseconds: 300),
        child: RawMaterialButton(
            key: ValueKey(index == selectIndex),
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            constraints: BoxConstraints(minWidth: 0.0, minHeight: 0.0),
            padding: EdgeInsets.all(8.0),
            child: _iconReplace(context, name, style),
            onPressed: () {
              if (selectIndex != index) {
                widget.selectItemChanged?.call(index);
              }
              setState(() {
                selectIndex = index;
              });
            }),
      ),
    );
  }

  Widget _iconReplace(BuildContext context, String name, TextStyle style) {

    if (name == GSYLocalizations.i18n(context)!.search_tab_repos) {
      return Icon(Icons.warehouse_rounded, color: Colors.white70,);
    } else if (name == GSYLocalizations.i18n(context)!.search_tab_user) {
      return Icon(Icons.account_circle_rounded, color: Colors.white70);
    }

    return new Text(
      name,
      style: style,
      textAlign: TextAlign.center,
    );
    // switch(name){
    //   case GSYLocalizations.i18n(context)!.search_tab_repos:
    //     return Icon(icon: Icons.warehouse_rounded);
    //     break;
    //   case GSYLocalizations.i18n(context)!.search_tab_user:
    //     return Icon(icon: Icons.account_circle_rounded);
    //     break;
    //   default:
    //     return Container();
    //     break;
    // }
  }

  _renderList(BuildContext context) {
    List<Widget> list = [];
    for (int i = 0; i < widget.itemNames.length; i++) {
      if (i == widget.itemNames.length - 1) {
        list.add(_renderItem(context, widget.itemNames[i], i));
      } else {
        list.add(_renderItem(context, widget.itemNames[i], i));
        list.add(new Container(
            width: 1.0, height: 25.0, color: GSYColors.subLightTextColor));
      }
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxWidth: MediaQuery.of(context).size.width*0.3,
        // maxHeight: MediaQuery.of(context).size.height*0.053

      ),
      // color: Colors.redAccent,
      child: new GSYCardItem(
          elevation: widget.elevation,
          margin: widget.margin,
          color: Theme.of(context).primaryColor,
          shape: widget.shape ??
              new RoundedRectangleBorder(
                borderRadius: BorderRadius.horizontal(right: Radius.circular(40.0)),
              ),
          child: new Row(
            children: _renderList(context),
          )),
    )
      ;
  }
}
