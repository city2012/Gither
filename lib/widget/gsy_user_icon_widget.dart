import 'package:flutter/material.dart';
import 'package:gsy_github_app_flutter/common/style/gsy_style.dart';
import 'package:transparent_image/transparent_image.dart';

/**
 * 头像Icon
 * Created by guoshuyu
 * Date: 2018-07-30
 */

class GSYUserIconWidget extends StatelessWidget {
  /**
   * Will use default icon when avatar is Empty
   */
  final String? image;
  final VoidCallback? onPressed;
  final double width;
  final double height;
  final EdgeInsetsGeometry? padding;
  final RoundedRectangleBorder shape;

  GSYUserIconWidget(
      {this.image,
      this.onPressed,
      this.width = 30.0,
      this.height = 30.0,
      this.padding,
      this.shape = const RoundedRectangleBorder(),
      });

  @override
  Widget build(BuildContext context) {

    return new RawMaterialButton(
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        padding:
            padding ?? const EdgeInsets.only(top: 4.0, right: 5.0, left: 5.0),
        constraints: const BoxConstraints(minWidth: 0.0, minHeight: 0.0),
        child: new ClipOval(

            child: FadeInImage(
              placeholder: MemoryImage(kTransparentImage),
              image: _networkImageWithDefault(image),
              // image: NetworkImage(image ?? GSYICons.DEFAULT_REMOTE_PIC),
              //预览图
              fit: BoxFit.fitWidth,
              width: width,
              height: height,
            )

        ),
        onPressed: onPressed);
  }

  ImageProvider _networkImageWithDefault(String? imageUrl){
    try{
      if(imageUrl!.isEmpty){
        return AssetImage(GSYICons.DEFAULT_USER_ICON);
      }
       return NetworkImage(imageUrl);
    }catch(e){
      return AssetImage(GSYICons.DEFAULT_USER_ICON);
    }

  }
}
