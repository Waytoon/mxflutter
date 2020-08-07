//  MXFlutterFramework
//  Copyright 2019 The MXFlutter Authors. All rights reserved.
//
//  Use of this source code is governed by a MIT-style license that can be
//  found in the LICENSE file.

import 'package:mxflutter/src/mirror/mx_mirror.dart';
import 'package:flutter/src/widgets/platform_view.dart';
import 'package:flutter/foundation.dart' ;
import 'package:flutter/gestures.dart' ;
import 'package:flutter/rendering.dart' ;
import 'package:flutter/services.dart' ;
import 'package:flutter/src/widgets/basic.dart' ;
import 'package:flutter/src/widgets/debug.dart' ;
import 'package:flutter/src/widgets/focus_manager.dart' ;
import 'package:flutter/src/widgets/focus_scope.dart' ;
import 'package:flutter/src/widgets/framework.dart' ;


///把自己能处理的类注册到分发器中
Map<String, MXFunctionInvoke> registerPlatformViewSeries() {
  var m = <String, MXFunctionInvoke>{};
  m[_androidView.funName] = _androidView;
  m[_uiKitView.funName] = _uiKitView;
  m[_htmlElementView.funName] = _htmlElementView;
  m[_platformViewLink.funName] = _platformViewLink;
  m[_platformViewSurface.funName] = _platformViewSurface;
  return m;
}
var _androidView = MXFunctionInvoke(
    "AndroidView",
    (
      {
      Key key,
      String viewType,
      dynamic onPlatformViewCreated,
      PlatformViewHitTestBehavior hitTestBehavior = PlatformViewHitTestBehavior.opaque,
      TextDirection layoutDirection,
      Set<Factory<OneSequenceGestureRecognizer>> gestureRecognizers,
      dynamic creationParams,
      MessageCodec<dynamic> creationParamsCodec,
      }
    ) =>
      AndroidView(
      key: key,
      viewType: viewType,
      onPlatformViewCreated: createValueChangedGenericClosure<int>(_androidView.buildOwner, onPlatformViewCreated),
      hitTestBehavior: hitTestBehavior,
      layoutDirection: layoutDirection,
      gestureRecognizers: gestureRecognizers,
      creationParams: creationParams,
      creationParamsCodec: creationParamsCodec,
    ),
);
var _uiKitView = MXFunctionInvoke(
    "UiKitView",
    (
      {
      Key key,
      String viewType,
      dynamic onPlatformViewCreated,
      PlatformViewHitTestBehavior hitTestBehavior = PlatformViewHitTestBehavior.opaque,
      TextDirection layoutDirection,
      dynamic creationParams,
      MessageCodec<dynamic> creationParamsCodec,
      Set<Factory<OneSequenceGestureRecognizer>> gestureRecognizers,
      }
    ) =>
      UiKitView(
      key: key,
      viewType: viewType,
      onPlatformViewCreated: createValueChangedGenericClosure<int>(_uiKitView.buildOwner, onPlatformViewCreated),
      hitTestBehavior: hitTestBehavior,
      layoutDirection: layoutDirection,
      creationParams: creationParams,
      creationParamsCodec: creationParamsCodec,
      gestureRecognizers: gestureRecognizers,
    ),
);
var _htmlElementView = MXFunctionInvoke(
    "HtmlElementView",
    (
      {
      Key key,
      String viewType,
      }
    ) =>
      HtmlElementView(
      key: key,
      viewType: viewType,
    ),
);
var _platformViewLink = MXFunctionInvoke(
    "PlatformViewLink",
    (
      {
      Key key,
      dynamic surfaceFactory,
      dynamic onCreatePlatformView,
      String viewType,
      }
    ) =>
      PlatformViewLink(
      key: key,
      surfaceFactory: null,
      onCreatePlatformView: null,
      viewType: viewType,
    ),
);
var _platformViewSurface = MXFunctionInvoke(
    "PlatformViewSurface",
    (
      {
      Key key,
      PlatformViewController controller,
      PlatformViewHitTestBehavior hitTestBehavior,
      Set<Factory<OneSequenceGestureRecognizer>> gestureRecognizers,
      }
    ) =>
      PlatformViewSurface(
      key: key,
      controller: controller,
      hitTestBehavior: hitTestBehavior,
      gestureRecognizers: gestureRecognizers,
    ),
);
