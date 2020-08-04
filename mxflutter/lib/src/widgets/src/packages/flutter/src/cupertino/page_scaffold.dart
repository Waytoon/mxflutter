//  MXFlutterFramework
//  Copyright 2019 The MXFlutter Authors. All rights reserved.
//
//  Use of this source code is governed by a MIT-style license that can be
//  found in the LICENSE file.

import 'package:mxflutter/src/mirror/mx_mirror.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/cupertino/page_scaffold.dart';


class MXProxyPageScaffold {
  ///把自己能处理的类注册到分发器中
  static Map<String, MXFunctionInvoke> registerSeries() {
    var m = <String, MXFunctionInvoke>{};
    m[cupertinoPageScaffold.funName] = cupertinoPageScaffold;
    return m;
  }
  static var cupertinoPageScaffold = MXFunctionInvoke(
      "CupertinoPageScaffold",
      ({
        Key key,
        ObstructingPreferredSizeWidget navigationBar,
        Color backgroundColor,
        bool resizeToAvoidBottomInset = true,
        Widget child,
      }) =>
        CupertinoPageScaffold(
        key: key,
        navigationBar: navigationBar,
        backgroundColor: backgroundColor,
        resizeToAvoidBottomInset: resizeToAvoidBottomInset,
        child: child,
      ),
    );
}
