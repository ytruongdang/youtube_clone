// import 'package:flutter/material.dart';
// import 'package:meta/meta.dart';
// import 'menu.dart';

// const double _kFlingVelocity = 2.0;

// class Backdrop extends StatefulWidget {
//   final MenuCategory currentCategory;
//   final Widget frontLayer;
//   final Widget backLayer;
//   final Widget frontTitle;
//   final Widget backTitle;

//   const Backdrop({
//     @required this.currentCategory,
//     @required this.frontLayer,
//     @required this.backLayer,
//     @required this.frontTitle,
//     @required this.backTitle,
//   })  : assert(currentCategory != null),
//     assert(frontLayer != null),
//     assert(backLayer != null),
//     assert(frontTitle != null),
//     assert(backTitle != null);

//   @override
//   _BackdropState createState() => _BackdropState();
// }

// class _BackdropState extends State<Backdrop>
//   with SingleTickerProviderStateMixin {
//   final GlobalKey _backdropKey = GlobalKey(debugLabel: 'Backdrop');

//   AnimationController _controller;

//   @override
//   void initState() {
//     super.initState();
//     _controller = AnimationController(
//     duration: Duration(milliseconds: 300),
//     value: 1.0,
//     vsync: this,
//   );
// }

// @override
// void dispose() {
//   _controller.dispose();
//   super.dispose();
// }

// @override
// void didUpdateWidget(Backdrop old) {
//   super.didUpdateWidget(old);

//   if (widget.currentCategory != old.currentCategory) {
//     _toggleBackdropLayerVisibility();
//   } else if (!_frontLayerVisible) {
//     _controller.fling(velocity: _kFlingVelocity);
//   }
// }

// Widget _buildStack(BuildContext context, BoxConstraints constraints) {
//   const double layerTitleHeight = 48.0;
//   final Size layerSize = constraints.biggest;
//   final double layerTop = layerSize.height - layerTitleHeight;

//   Animation<RelativeRect> layerAnimation = RelativeRectTween(
//     begin: RelativeRect.fromLTRB(
//         0.0, layerTop, 0.0, layerTop - layerSize.height),
//     end: RelativeRect.fromLTRB(0.0, 0.0, 0.0, 0.0),
//   ).animate(_controller.view);

//   return Stack(
//     key: _backdropKey,
//     children: <Widget>[
//       widget.backLayer,
//       PositionedTransition(
//         rect: layerAnimation,
//         child: _FrontLayer(
//           onTap: _toggleBackdropLayerVisibility,
//           child: widget.frontLayer,
//         ),
//       ),
//     ],
//   );
// }

// @override
// Widget build(BuildContext context) {
//   var appBar = AppBar(
//     brightness: Brightness.light,
//     elevation: 0.0,
//     titleSpacing: 0.0,
//     title: _BackdropTitle(
//       animationController: _controller,
//       onPress: _toggleBackdropLayerVisibility,
//       frontTitle: widget.frontTitle,
//       backTitle: widget.backTitle,
//     ),
//     actions: <Widget>[
//       IconButton(
//         icon: Icon(Icons.search),
//         onPressed: () {
//           // TODO
//         },
//       )
//     ],
//   );
//   return Scaffold(
//     appBar: appBar,
//     body: LayoutBuilder(builder: _buildStack)
//   );
// }

// bool get _frontLayerVisible {
//   final AnimationStatus status = _controller.status;
//   return status == AnimationStatus.completed ||
//       status == AnimationStatus.forward;
// }

// void _toggleBackdropLayerVisibility() {
//   _controller.fling(
//       velocity: _frontLayerVisible ? -_kFlingVelocity : _kFlingVelocity);
//   }
// }

// class _FrontLayer extends StatelessWidget {
//   const _FrontLayer({
//     Key key,
//     this.onTap,
//     this.child,
//   }) : super(key: key);

//   final VoidCallback onTap;
//   final Widget child;

//   @override
//   Widget build(BuildContext context) {
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
//             onTap: onTap,
//             child: Container(
//               height: 40.0,
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

// class _BackdropTitle extends AnimatedWidget {
//   final AnimationController animationController;
//   final Function onPress;
//   final Widget frontTitle;
//   final Widget backTitle;

//   _BackdropTitle({
//     Key key,
//     this.onPress,
//     @required this.frontTitle,
//     @required this.backTitle,
//     @required this.animationController,
//   })  : assert(frontTitle != null),
//     assert(backTitle != null),
//     assert(animationController != null),
//     super(key: key, listenable: animationController.view);

//   @override
//   Widget build(BuildContext context) {
//     final Animation<double> animation = this.listenable;

//     return DefaultTextStyle(
//       style: Theme.of(context).primaryTextTheme.title,
//       softWrap: false,
//       overflow: TextOverflow.ellipsis,
//       child: Row(children: <Widget>[
//         // branded icon
//         SizedBox(
//           width: 72.0,
//           child: IconButton(
//             padding: EdgeInsets.only(right: 8.0),
//             onPressed: this.onPress,
//             icon: Stack(children: <Widget>[
//               new Opacity(
//                 opacity: new CurvedAnimation(
//                   parent: new ReverseAnimation(animation),
//                   curve: const Interval(0.5, 1.0),
//                 ).value,
//                 child: new AnimatedBuilder(
//                   animation: animationController,
//                   child: new Container(
//                     child: new Icon(Icons.close),
//                   ),
//                   builder: (BuildContext context, Widget _widget) {
//                     return new Transform.rotate(
//                       angle: animationController.value * -6.3,
//                       child: _widget,
//                     );
//                   },
//                 ),
//               ),
//               new Opacity(
//                 opacity: new CurvedAnimation(
//                   parent: animation,
//                   curve: const Interval(0.5, 1.0),
//                 ).value,
//                 child: new AnimatedBuilder(
//                   animation: animationController,
//                   child: new Container(
//                     child: new Icon(Icons.menu),
//                   ),
//                   builder: (BuildContext context, Widget _widget) {
//                     return new Transform.rotate(
//                       angle: animationController.value * 6.3,
//                       child: _widget,
//                     );
//                   },
//                 ),
//               ),
//             ]),
//           ),
//         ),
//         // Here, we do a custom cross fade between backTitle and frontTitle.
//         // This makes a smooth animation between the two texts.
//         Stack(
//           children: <Widget>[
//             Opacity(
//               opacity: CurvedAnimation(
//                 parent: ReverseAnimation(animation),
//                 curve: Interval(0.5, 1.0),
//               ).value,
//               child: FractionalTranslation(
//                 translation: Tween<Offset>(
//                   begin: Offset.zero,
//                   end: Offset(0.5, 0.0),
//                 ).evaluate(animation),
//                 child: backTitle,
//               ),
//             ),
//             Opacity(
//               opacity: CurvedAnimation(
//                 parent: animation,
//                 curve: Interval(0.5, 1.0),
//               ).value,
//               child: FractionalTranslation(
//                 translation: Tween<Offset>(
//                   begin: Offset(-0.25, 0.0),
//                   end: Offset.zero,
//                 ).evaluate(animation),
//                 child: frontTitle,
//               ),
//             ),
//           ],
//         )
//       ]),
//     );
//   }
// }
