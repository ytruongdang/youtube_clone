import 'package:flutter/material.dart';
import './comment_sliver_list.dart';
import './comment_sliver_form.dart';
import './video_related_sliver_list.dart';
import './video_info_sliver_list.dart';
import '../model.dart';

class VideoRelatedInfo extends AnimatedWidget {
	VideoRelatedInfo({
		Key key,
		Animation animation,
		this.height,
		this.onDismiss,
    this.status,
    this.playerHeight,
	}) : super(key: key, listenable: animation);

	final double height;
	final VoidCallback onDismiss;
  final String status;
  final double playerHeight;

	get containerHeight {
		return new Tween(begin: height, end: 0.0)
				.animate(listenable)
				.value;
	}

	get containerOpacity {
		return new Tween(begin: 1.0, end: 0.0)
				.animate(listenable)
				.value;
	}

	Widget getFullContent() {
    // print(">>>>>>>> video relate info ${status}");
    // if(status != 'full') {
    //   return Container(
    //     color: Colors.white,
    //     height: playerHeight,
    //     child: Image.asset('assets/images/video_thumbnail.jpg'),
    //   );
    // }
		return Container(
      height: containerHeight,
      child: Opacity(
			opacity: containerOpacity,
        child: CustomScrollView(
          slivers: <Widget>[
            VideoInfoSliverList(),
            VideoRelatedSliverList(),
            CommentSliverForm(),
            CommentSliverList()
          ],
        ),
      )
			);
	}

	Widget getMinimizedContent() {
		return Row(
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
		);
	}


	@override
	Widget build(BuildContext context) {
		Animation animation = listenable;

		if (animation.value == 1.0 && status != 'full') return Container();
		return getFullContent();
	}
}