import 'dart:async';

import 'package:flutter/material.dart';
import 'package:youtube_clone/detail_page.dart';

class ManagerDetailPage {

  static final ManagerDetailPage _instance = ManagerDetailPage._internal();

  StreamController<String> streamController = new StreamController.broadcast();   //Add .broadcast here

  bool showDetail = false;

  factory ManagerDetailPage() {
    return _instance;
    // if(_instance != null) {
    //   return ManagerDetailPage._instance;
    // }else {
    //   return ManagerDetailPage._internal();
    // }
  }

  ManagerDetailPage._internal();

  setDetailPage(BuildContext context) {
    print("setDetailPage");
    return showDetail ?  DetailPage() : Container();
  }

  void showDetailPage() {
    showDetail = true;
  }

  bool getState() {
    return showDetail;
  }

  listener() {
    return streamController.stream;
  }

  addDatatListener(dynamic data) {
    streamController.add(data);
  }

  disposeListener() {
    streamController.close();
  }

}