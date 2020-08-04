//  MXFlutterFramework
//  Copyright 2019 The MXFlutter Authors. All rights reserved.
//
//  Use of this source code is governed by a MIT-style license that can be
//  found in the LICENSE file.

import 'package:mxflutter/src/mirror/mx_mirror.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/painting/shader_warm_up.dart';


class MXProxyShaderWarmUp {
  ///把自己能处理的类注册到分发器中
  static Map<String, MXFunctionInvoke> registerSeries() {
    var m = <String, MXFunctionInvoke>{};
    m[defaultShaderWarmUp.funName] = defaultShaderWarmUp;
    return m;
  }
  static var defaultShaderWarmUp = MXFunctionInvoke(
      "DefaultShaderWarmUp",
      ({
        dynamic drawCallSpacing = 0.0,
        Size canvasSize,
      }) =>
        DefaultShaderWarmUp(
        drawCallSpacing: drawCallSpacing?.toDouble(),
        canvasSize: canvasSize,
      ),
    );
}
