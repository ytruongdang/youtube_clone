import 'package:flutter/material.dart';
import 'package:youtube_clone/video_player.dart';
import './model.dart';
import './widgets/video_related_info.dart';

typedef DragUpdateCallback(double value);
typedef DragEndCallback(double value);

const double _bottomNavigationBarHeight = 56.0;
const double _spacing = 8.0;
const double _minimizedPlayerHeight = 80.0;
const double bottomHeight =_bottomNavigationBarHeight + _spacing;

class VideoScreen extends AnimatedWidget {
	VideoScreen({
		Key key,
		Animation animation,
		this.status,
		this.screenWidth,
		this.screenHeight,
		this.onDragUpdate,
		this.onDragEnd,
		this.onDismiss,
    this.onTapFullScreen,
    this.data
	})
			: super(key: key, listenable: animation);
	final String status;
	final double screenWidth;
	final double screenHeight;
	final DragUpdateCallback onDragUpdate;
	final DragEndCallback onDragEnd;
	final VoidCallback onDismiss;
  final VoidCallback onTapFullScreen;
  final dynamic data;

	Animation getVideoRelativeRect(BuildContext context) {
    // print("getVideoRelateiveRect ${status}");
		// double bottomHeight = _bottomNavigationBarHeight + _spacing;
		RelativeRect hiddenRect = new RelativeRect.fromLTRB(
				0.0,
				screenHeight - 1.0,
				0.0,
				0.0
		);
		RelativeRect fullSizeRect = new RelativeRect.fromLTRB(0.0, 0.0, 0.0, 0.0);
		RelativeRect minimizedRect = new RelativeRect.fromLTRB(
				_spacing,
				screenHeight - bottomHeight - _minimizedPlayerHeight,
				_spacing,
				bottomHeight
		);

		// RelativeRectTween tween = new RelativeRectTween(
		// 		begin: hiddenRect,
		// 		end: fullSizeRect
		// );

		if (status == 'full') {
			return RelativeRectTween(
					begin: fullSizeRect,
					end: minimizedRect
			).animate(listenable);
		} else {
			return RelativeRectTween(
					begin: hiddenRect,
					end: fullSizeRect
			).animate(listenable);
		}
		// return tween.animate(listenable);
	}

	handleVerticalDragUpdate(DragUpdateDetails details) {
		onDragUpdate(details.primaryDelta / screenHeight);
	}

	handleVerticalDragEnd(DragEndDetails details) {
		onDragEnd(details.velocity.pixelsPerSecond.dy / screenHeight);
	}

	Widget getHiddenContent() {
		return Container(
			color: Colors.white,
			child: Container(
				alignment: Alignment.topLeft,
				height: playerHeight,
				// child: Image.asset('assets/images/video_thumbnail.jpg'),
			),
		);
	}

  Widget minimizedInfo() {
    Animation animation = listenable;
    // print(animation.value);
    // print("${status} ????????????? ${animation.value}");
    if(status == 'full') {
      if(animation.value == 1.0) {
        return Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            // mainAxisSize: mainAsixSize.max
            children: <Widget>[
              Expanded(
                // flex: 3,
                child: Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(MOCK_VIDEO.name, maxLines: 1,
                        overflow: TextOverflow.ellipsis,),
                      SizedBox(height: 8.0,),
                      Text(MOCK_VIDEO.channelName, maxLines: 1,
                          overflow: TextOverflow.ellipsis),
                    ],),
                ),
              ),
              Container(
                width: 100.0,
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    IconButton(icon: Icon(Icons.pause, size: 20.0), onPressed: () {},),
                    IconButton(icon: Icon(Icons.close, size: 20.0), onPressed: onDismiss,)
                  ],
                ),)
            ],
          )
        );
      }else {
        return Container();
      }
    }
    return Container();
  }

	Widget getFullContent() {
    
    double height = status == 'full' ? Tween(
					begin: playerHeight, end: _minimizedPlayerHeight)
					.animate(listenable)
					.value :playerHeight;
    double heightanimation = Tween( begin: 0.0, end: playerHeight).animate(listenable).value;
    print("start fullScreen Content ${status} ${playerHeight} ${heightanimation}");
		Widget player = GestureDetector(
      onVerticalDragUpdate: handleVerticalDragUpdate,
			onVerticalDragEnd: handleVerticalDragEnd,
      onTap: onTapFullScreen,
      child: Container(
        // color: Colors.redAccent,
        alignment: Alignment.center,
        width: screenWidth,
        height: status == 'hidden' ? heightanimation : height,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container(
              child: Stack(
                children: <Widget>[
                  Image.asset('assets/images/video_thumbnail.jpg'),
                  status == 'full' ? TopVideoPlayer('https://bitdash-a.akamaihd.net/content/MI201109210084_1/m3u8s/f08e80da-bf1d-4e3d-8899-f0f6155f6efa.m3u8') :Container(),
                  // Text(data.toString(), style: TextStyle(color: Colors.green, fontSize: 16.0),)
                ],
              ),
            ),
            minimizedInfo()
          ],
        )
        
      ),
    );
    
		Widget subContent = VideoRelatedInfo(
			animation: listenable,
			height: videoInfoHeight,
      playerHeight: playerHeight,
			onDismiss: onDismiss,
      status: status,
		);
		return Material(
      child: Container(
        color: Colors.white,
        width: screenWidth,
        child: Stack(
          children: <Widget>[
            Container(
              // color: Color.fromRGBO(0, 0, 0, 0.5),
              color: Colors.white,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                player,
                Expanded(
                  child: subContent,
                ),
              ],
            ),
          ],
        )
        
      ),
    );
	}

	get playerHeight {
		final double playerRatio = 16 / 9;
		return screenWidth / playerRatio;
	}

	get videoInfoHeight {
		return screenHeight - playerHeight;
	}

	@override
	Widget build(BuildContext context) {
		// Animation animation = listenable;
		Widget content;

		// if (status == 'full') {
		//   content = getFullContent();
		// } else {
		// 	content = getHiddenContent();
		// }

    content = getFullContent();
    // if(status == 'full') {
      return PositionedTransition(
        rect: getVideoRelativeRect(context),
        child: content,
      );
    // }else {
      // return Container(color: Colors.blue,);
    // }
	}
}