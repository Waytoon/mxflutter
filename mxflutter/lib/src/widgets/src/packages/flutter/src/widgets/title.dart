//  MXFlutterFramework
//  Copyright 2019 The MXFlutter Authors. All rights reserved.
//
//  Use of this source code is governed by a MIT-style license that can be
//  found in the LICENSE file.

import 'package:mxflutter/src/mirror/mx_mirror.dart';
import 'package:flutter/src/widgets/title.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/basic.dart';
import 'package:flutter/src/widgets/framework.dart';


///把自己能处理的类注册到分发器中
Map<String, MXFunctionInvoke> registerTitleSeries() {
  var m = <String, MXFunctionInvoke>{};
  m[_title.funName] = _title;
  return m;
}
var _title = MXFunctionInvoke(
    "Title",
    (
      {
      Key key,
      String title = '',
      Color color,
      Widget child,
      }
    ) =>
      Title(
      key: key,
      title: title,
      color: color,
      child: child,
    ),
);
