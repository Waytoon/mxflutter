//  MXFlutterFramework
//  Copyright 2019 The MXFlutter Authors. All rights reserved.
//
//  Use of this source code is governed by a MIT-style license that can be
//  found in the LICENSE file.

import 'package:mxflutter/src/mirror/mx_mirror.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/sliver_layout_builder.dart';


class MXProxySliverLayoutBuilder {
  ///把自己能处理的类注册到分发器中
  static Map<String, MXFunctionInvoke> registerSeries() {
    var m = <String, MXFunctionInvoke>{};
    m[sliverLayoutBuilder.funName] = sliverLayoutBuilder;
    return m;
  }
  static var sliverLayoutBuilder = MXFunctionInvoke(
      "SliverLayoutBuilder",
      ({
        Key key,
        dynamic builder,
      }) =>
        SliverLayoutBuilder(
        key: key,
        builder: builder,
      ),
    );
}
