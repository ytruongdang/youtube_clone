import 'package:flutter/material.dart';
import 'package:youtube_clone/app.dart';
import 'package:youtube_clone/video_screen.dart';
// import './detail_page.dart';
import './manager_detail_page.dart';
import './video_player_manager.dart';

const double _kFlingVelocity = 2.0;
const double _bottomNavigationBarHeight = 56.0;
const double _spacing = 8.0;
const double _minimizedPlayerHeight = 80.0;
const double bottomHeight =_bottomNavigationBarHeight + _spacing;

void main() async{
  final manegerDetailPage = ManagerDetailPage();
  runApp(MyApp(manegerDetailPage));
}

class MyApp extends StatefulWidget {
  final ManagerDetailPage managerDetailPage;
  MyApp(this.managerDetailPage);
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with SingleTickerProviderStateMixin {

  final GlobalKey _backdropKey = GlobalKey(debugLabel: 'Backdrop');
  AnimationController controller;
	Animation animation;
	String videoScreenStatus;
  MyVideoPlayer _videoPlaerController;
  dynamic data;

  @override
  void initState() {
    super.initState();
    videoScreenStatus = 'hidden';
		controller = new AnimationController(
        // value: -1.0,
				vsync: this,
				duration: Duration(milliseconds: 10000)
		);
		// animation = new CurvedAnimation(parent: controller, curve: Curves.linear)
		// 	..addListener(() {
		// 		setState(() {});
		// 	});

    widget.managerDetailPage.listener().listen((data) {
      handleVideoItemPressed(data);
    }, onDone: () {
      print("listener data page onDone");
    }, onError: (error) {
      print("listener data page onError");
    });
  }

  handleVideoItemPressed(dynamic itemdata) {
    _toggleBackdropLayerVisibility();
    // print("listener data page  ${itemdata}");
    // print(" handleVideoItemPressed >>>>>dsa d as d as d asd a");
    if(videoScreenStatus == 'hidden') {
      // setState(() {
      //   // controller.value = 0.0;
      //   // videoScreenStatus = 'start';
      // });
      controller.fling(velocity: _kFlingVelocity)
        ..whenComplete(() {
          print("   asd as d asd as d asd as d asd a");
          _videoPlaerController = MyVideoPlayer.fact('topVideo', 'https://bitdash-a.akamaihd.net/content/MI201109210084_1/m3u8s/f08e80da-bf1d-4e3d-8899-f0f6155f6efa.m3u8');
          setState(() {
            controller.value = 0.0;
            videoScreenStatus = 'full';
            data = itemdata;
          });
        });
    }else {
      setState(() {
        controller.value = 0.0;
        videoScreenStatus = 'full';
        data = itemdata;
      });
      controller.fling(velocity: -_kFlingVelocity);
    }
	}

  showFullScreen() {
    controller.fling(velocity: -_kFlingVelocity);
  }

	handleDismissVideoScreen() {
    
		setState(() {
			videoScreenStatus = 'hidden';
			controller.value = 0.0;
		});
		if(_videoPlaerController != null) {
      _videoPlaerController.dispose();
      _videoPlaerController.removePlayer('topVideo');
    }
    // controller.dispose();
	}

	handleVideoScreenDragUpdate(delta) {
    print("handleVideoScreenDragUpdate");
		setState(() {
			controller.value += delta;
		});
	}

	handleVideoScreenDragEnd(flingVelocity) {
    print("handleVideoScreenDragUpdate");
		if (flingVelocity > 0) {
      print("video player fullScreen");
      // setState(() {
      //   videoScreenStatus = 'minimized';
      // });
			controller.fling(velocity: _kFlingVelocity);
		} else if (flingVelocity < 0) {
			controller.fling(velocity: -_kFlingVelocity);
		} else {
			if (controller.value > 0.4) {
				controller.fling(velocity: _kFlingVelocity);
			} else {
				controller.fling(velocity: -_kFlingVelocity);
			}
		}
	}

  bool get _frontLayerVisible {
    final AnimationStatus status = controller.status;
    return status == AnimationStatus.completed ||
        status == AnimationStatus.forward;
  }
  void _toggleBackdropLayerVisibility() {
    controller.fling(
        velocity: _frontLayerVisible ? -_kFlingVelocity : _kFlingVelocity);
  }

  @override
  void dispose() {
    // widget.managerDetailPage.disposeListener();
    controller.dispose();
    super.dispose();
  }

  	Animation getVideoRelativeRect(BuildContext context, double screenHeight, ) {
    // print("getVideoRelateiveRect ${status}");
		// double bottomHeight = _bottomNavigationBarHeight + _spacing;
		RelativeRect hiddenRect = new RelativeRect.fromLTRB(
				0.0,
				screenHeight,
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

		RelativeRectTween tween = new RelativeRectTween(
				begin: hiddenRect,
				end: fullSizeRect
		);

		if (_frontLayerVisible) {
			tween = new RelativeRectTween(
					begin: fullSizeRect,
					end: minimizedRect
			);
		}
		return tween.animate(controller.view);
	}

  @override
  Widget build(BuildContext context) {
    
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LayoutBuilder(builder: (context, constraints) {
        // const double layerTitleHeight = 248.0;
        // final Size layerSize = constraints.biggest;
        // final bottomHeight =constraints.
        // final double layerTop = layerSize.height - layerTitleHeight;

        // Animation<RelativeRect> layerAnimation = RelativeRectTween(
        //   begin: RelativeRect.fromLTRB(
        //       0.0, layerTop, 0.0, layerTop - layerSize.height),
        //   end: RelativeRect.fromLTRB(0.0, 0.0, 0.0, 0.0),
        // ).animate(controller.view);
        return Stack(
          key: _backdropKey,
          alignment: Alignment.bottomCenter,
          children: <Widget>[
            App(),
            // _BackDropOpacity(animationController: controller,),
            // PositionedTransition(
            //   rect: getVideoRelativeRect(context, layerSize.height),
            //   child: _FrontLayer(
            //     onTap: () => _toggleBackdropLayerVisibility(),
            //     onDragEnd: handleVideoScreenDragEnd,
            //     onDragUpdate: handleVideoScreenDragUpdate,
            //     screenHeight: layerSize.height,
            //     child: Container(
            //       height: 300.0,
            //       color: Colors.blue,
            //     ),
            //   )
            // ),
            VideoScreen(
              animation: controller.view,
              status: videoScreenStatus,
              screenWidth: constraints.maxWidth,
              screenHeight: constraints.maxHeight,
              onDragUpdate: handleVideoScreenDragUpdate,
              onDragEnd: handleVideoScreenDragEnd,
              onDismiss: handleDismissVideoScreen,
              onTapFullScreen: showFullScreen,
              data: data
            )
          ],
        );
      })
    );
  }
}

// class _BackDropOpacity extends AnimatedWidget {
//   final AnimationController animationController;

//   _BackDropOpacity({
//     Key key,
//     this.animationController
//   }) : assert(animationController != null), super(key: key, listenable:animationController);

//   @override
//   Widget build(BuildContext context) {
//     final Animation<double> animation = this.listenable;
//     return Container(
//       color: Color.fromRGBO(0, 0, 0, 0.7),
//       child: Opacity(
//         opacity: CurvedAnimation(
//           parent: animation,
//           curve: Interval(0.5, 1.0),
//         ).value,
//         child: FractionalTranslation(
//           translation: Tween<Offset>(
//             begin: Offset(-0.25, 0.0),
//             end: Offset.zero,
//           ).evaluate(animation),
//           child: Text("dasd as dsa d a"),
//         ),
//       ),
//     );
//   }

// }
// typedef DragUpdateCallback(double value);
// typedef DragEndCallback(double value);

// class _FrontLayer extends StatelessWidget {
//   const _FrontLayer({
//     Key key,
//     this.onTap,
//     this.child,
//     this.onDragUpdate,
//     this.onDragEnd,
//     this.onTapFullScreen,
//     this.screenHeight
//   }) : super(key: key);

//   final VoidCallback onTap;
//   final Widget child;
//   final DragUpdateCallback onDragUpdate;
//   final DragEndCallback onDragEnd;
//   final double screenHeight;
// 	// final VoidCallback onDismiss;
//   final VoidCallback onTapFullScreen;
//   // final VoidCallback handleVerticalDragUpdate;
//   // final VoidCallback handleVerticalDragEnd;
//   // final VoidCallback onTapFullScreen;

//   handleVerticalDragUpdate(DragUpdateDetails details) {
// 		onDragUpdate(details.primaryDelta / screenHeight);
// 	}

// 	handleVerticalDragEnd(DragEndDetails details) {
// 		onDragEnd(details.velocity.pixelsPerSecond.dy / screenHeight);
// 	}



//   @override
//   Widget build(BuildContext context) {
//     final statusBarHeight = MediaQuery.of(context).padding.top;
//     return Material(
//       elevation: 16.0,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.only(
//           topLeft: Radius.circular(16.0),
//           topRight: Radius.circular(16.0)
//         ),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.stretch,
//         children: <Widget>[
//           GestureDetector(
//             behavior: HitTestBehavior.opaque,
//             onVerticalDragUpdate: handleVerticalDragUpdate,
//             onVerticalDragEnd: handleVerticalDragEnd,
//             onTap: onTapFullScreen,
//             child: Container(
//               margin: EdgeInsets.only(top: statusBarHeight),
//               height: 100.0,
//               color: Colors.black,
//               alignment: AlignmentDirectional.centerStart,
//             ),
//           ),
//           Expanded(
//             child: child,
//           ),
//         ],
//       ),
//     );
//   }
// }

