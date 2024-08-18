import 'package:flutter/material.dart';


class AnimatedBottomBar extends StatefulWidget {
  final List<BarItem> barItems;
  final Duration animationDuration;
  final Function? onBarTap;
  final Function? onBarDoubleTap;
  final BarStyle? barStyle;
  final Color? backgroundColor;

  AnimatedBottomBar(
      {required this.barItems,
      this.animationDuration = const Duration(milliseconds: 500),
      this.onBarTap,
      this.barStyle,
      this.backgroundColor,
      this.onBarDoubleTap});

  @override
  _AnimatedBottomBarState createState() => _AnimatedBottomBarState();
}

class _AnimatedBottomBarState extends State<AnimatedBottomBar>
    with TickerProviderStateMixin {
  int selectedBarIndex = 0;
  TabController? _tabController;

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 10.0,
      color: widget.backgroundColor != null
          ? widget.backgroundColor
          : Theme.of(context).primaryColor,
      child: SafeArea(
        maintainBottomViewPadding: true,
        child: SizedBox(
          height: Scaffold.of(context).appBarMaxHeight! * 0.6,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: _buildBarItems(),
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildBarItems() {
    List<Widget> _barItems = List.empty(growable: true);
    for (int i = 0; i < widget.barItems.length; i++) {
      BarItem item = widget.barItems[i];
      bool isSelected = selectedBarIndex == i;
      _barItems.add(InkWell(
        splashColor: Colors.transparent,
        onTap: () {
          setState(() {
            selectedBarIndex = i;
            widget.onBarTap!(selectedBarIndex);
          });
        },
        // onDoubleTap: (){
        //   setState(() {
        //     selectedBarIndex = i;
        //     widget.onBarDoubleTap!(selectedBarIndex);
        //   });
        // },
        child: AnimatedContainer(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          duration: widget.animationDuration,
          decoration: BoxDecoration(
              color: isSelected
                  ? item.color?.withOpacity(0.15)
                  : Colors.transparent,
              borderRadius: BorderRadius.all(Radius.circular(30))),
          child: Row(
            children: <Widget>[
              Icon(
                isSelected ? item.iconDataSelected : item.iconData,
                color: isSelected ? item.color : Colors.grey,
                size: widget.barStyle!.iconSize,
              ),
              SizedBox(
                width: 10.0,
              ),
              AnimatedSize(
                duration: widget.animationDuration,
                curve: Curves.easeInOut,
                child: Text(
                  isSelected ? item.text! : "",
                  style: TextStyle(
                      color: item.color,
                      fontWeight: widget.barStyle!.fontWeight,
                      fontSize: widget.barStyle!.fontSize),
                ),
              )
            ],
          ),
        ),
      ));
    }
    return _barItems;
  }

  @override
  void initState() {
    super.initState();
    _tabController =
        new TabController(vsync: this, length: widget.barItems.length);
  }

  ///整个页面dispose时，记得把控制器也dispose掉，释放内存
  @override
  void dispose() {
    _tabController!.dispose();
    super.dispose();
  }
}

class BarStyle {
  final double fontSize, iconSize;
  final FontWeight fontWeight;

  BarStyle(
      {this.fontSize = 18.0,
      this.iconSize = 32,
      this.fontWeight = FontWeight.w600});
}

class BarItem {
  String? text;
  IconData? iconData;
  IconData? iconDataSelected;
  Color? color;

  BarItem({this.text, this.iconData, this.color, this.iconDataSelected});
}
