//  MXFlutterFramework
//  Copyright 2019 The MXFlutter Authors. All rights reserved.
//
//  Use of this source code is governed by a MIT-style license that can be
//  found in the LICENSE file.

import 'package:mxflutter/src/mirror/mx_mirror.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/cupertino/route.dart';


class MXProxyRoute {
  ///把自己能处理的类注册到分发器中
  static Map<String, MXFunctionInvoke> registerSeries() {
    var m = <String, MXFunctionInvoke>{};
    m[cupertinoPageRoute.funName] = cupertinoPageRoute;
    m[cupertinoPageTransition.funName] = cupertinoPageTransition;
    m[cupertinoFullscreenDialogTransition.funName] = cupertinoFullscreenDialogTransition;
    return m;
  }
  static var cupertinoPageRoute = MXFunctionInvoke(
      "CupertinoPageRoute",
      ({
        dynamic builder,
        String title,
        RouteSettings settings,
        bool maintainState = true,
        bool fullscreenDialog = false,
      }) =>
        CupertinoPageRoute(
        builder: createGenericValueGenericClosure<Widget, BuildContext>(cupertinoPageRoute.buildOwner, builder),
        title: title,
        settings: settings,
        maintainState: maintainState,
        fullscreenDialog: fullscreenDialog,
      ),
    );
  static var cupertinoPageTransition = MXFunctionInvoke(
      "CupertinoPageTransition",
      ({
        Key key,
        Animation<double> primaryRouteAnimation,
        Animation<double> secondaryRouteAnimation,
        Widget child,
        bool linearTransition,
      }) =>
        CupertinoPageTransition(
        key: key,
        primaryRouteAnimation: primaryRouteAnimation,
        secondaryRouteAnimation: secondaryRouteAnimation,
        child: child,
        linearTransition: linearTransition,
      ),
    );
  static var cupertinoFullscreenDialogTransition = MXFunctionInvoke(
      "CupertinoFullscreenDialogTransition",
      ({
        Key key,
        Animation<double> primaryRouteAnimation,
        Animation<double> secondaryRouteAnimation,
        Widget child,
        bool linearTransition,
      }) =>
        CupertinoFullscreenDialogTransition(
        key: key,
        primaryRouteAnimation: primaryRouteAnimation,
        secondaryRouteAnimation: secondaryRouteAnimation,
        child: child,
        linearTransition: linearTransition,
      ),
    );
}
