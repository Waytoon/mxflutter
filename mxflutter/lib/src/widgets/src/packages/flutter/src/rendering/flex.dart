//  MXFlutterFramework
//  Copyright 2019 The MXFlutter Authors. All rights reserved.
//
//  Use of this source code is governed by a MIT-style license that can be
//  found in the LICENSE file.

import 'package:mxflutter/src/mirror/mx_mirror.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/rendering/flex.dart';


class MXProxyFlex {
  ///把自己能处理的类注册到分发器中
  static Map<String, MXFunctionInvoke> registerSeries() {
    var m = <String, MXFunctionInvoke>{};
    m[flexFit.funName] = flexFit;
    m[flexParentData.funName] = flexParentData;
    m[mainAxisSize.funName] = mainAxisSize;
    m[mainAxisAlignment.funName] = mainAxisAlignment;
    m[crossAxisAlignment.funName] = crossAxisAlignment;
    m[renderFlex.funName] = renderFlex;
    return m;
  }
  static var flexFit = MXFunctionInvoke(
      "FlexFit",
      ({Map args}) => MXFlexFit.parse(args),
  );
  static var flexParentData = MXFunctionInvoke(
      "FlexParentData",
      ({
      }) =>
        FlexParentData(
      ),
    );
  static var mainAxisSize = MXFunctionInvoke(
      "MainAxisSize",
      ({Map args}) => MXMainAxisSize.parse(args),
  );
  static var mainAxisAlignment = MXFunctionInvoke(
      "MainAxisAlignment",
      ({Map args}) => MXMainAxisAlignment.parse(args),
  );
  static var crossAxisAlignment = MXFunctionInvoke(
      "CrossAxisAlignment",
      ({Map args}) => MXCrossAxisAlignment.parse(args),
  );
  static var renderFlex = MXFunctionInvoke(
      "RenderFlex",
      ({
        List<RenderBox> children,
        Axis direction = Axis.horizontal,
        MainAxisSize mainAxisSize = MainAxisSize.max,
        MainAxisAlignment mainAxisAlignment = MainAxisAlignment.start,
        CrossAxisAlignment crossAxisAlignment = CrossAxisAlignment.center,
        TextDirection textDirection,
        VerticalDirection verticalDirection = VerticalDirection.down,
        TextBaseline textBaseline,
      }) =>
        RenderFlex(
        children: children,
        direction: direction,
        mainAxisSize: mainAxisSize,
        mainAxisAlignment: mainAxisAlignment,
        crossAxisAlignment: crossAxisAlignment,
        textDirection: textDirection,
        verticalDirection: verticalDirection,
        textBaseline: textBaseline,
      ),
    );
}
class MXFlexFit {
  static Map str2VMap = {
    'FlexFit.tight': FlexFit.tight,
    'FlexFit.loose': FlexFit.loose,
  };
  static FlexFit parse(dynamic value) {
    if (value is Map) {
      var valueStr = value["_name"].trim();
      var v = str2VMap[valueStr];
      return v;
    } else {
      return value;
    }
  }
}
class MXMainAxisSize {
  static Map str2VMap = {
    'MainAxisSize.min': MainAxisSize.min,
    'MainAxisSize.max': MainAxisSize.max,
  };
  static MainAxisSize parse(dynamic value) {
    if (value is Map) {
      var valueStr = value["_name"].trim();
      var v = str2VMap[valueStr];
      return v;
    } else {
      return value;
    }
  }
}
class MXMainAxisAlignment {
  static Map str2VMap = {
    'MainAxisAlignment.start': MainAxisAlignment.start,
    'MainAxisAlignment.end': MainAxisAlignment.end,
    'MainAxisAlignment.center': MainAxisAlignment.center,
    'MainAxisAlignment.spaceBetween': MainAxisAlignment.spaceBetween,
    'MainAxisAlignment.spaceAround': MainAxisAlignment.spaceAround,
    'MainAxisAlignment.spaceEvenly': MainAxisAlignment.spaceEvenly,
  };
  static MainAxisAlignment parse(dynamic value) {
    if (value is Map) {
      var valueStr = value["_name"].trim();
      var v = str2VMap[valueStr];
      return v;
    } else {
      return value;
    }
  }
}
class MXCrossAxisAlignment {
  static Map str2VMap = {
    'CrossAxisAlignment.start': CrossAxisAlignment.start,
    'CrossAxisAlignment.end': CrossAxisAlignment.end,
    'CrossAxisAlignment.center': CrossAxisAlignment.center,
    'CrossAxisAlignment.stretch': CrossAxisAlignment.stretch,
    'CrossAxisAlignment.baseline': CrossAxisAlignment.baseline,
  };
  static CrossAxisAlignment parse(dynamic value) {
    if (value is Map) {
      var valueStr = value["_name"].trim();
      var v = str2VMap[valueStr];
      return v;
    } else {
      return value;
    }
  }
}
