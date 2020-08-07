//  MXFlutterFramework
//  Copyright 2019 The MXFlutter Authors. All rights reserved.
//
//  Use of this source code is governed by a MIT-style license that can be
//  found in the LICENSE file.

import 'package:mxflutter/src/mirror/mx_mirror.dart';
import 'package:flutter/src/widgets/routes.dart';
import 'dart:async';
import 'dart:ui' as ui;
import 'package:flutter/foundation.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/src/widgets/basic.dart';
import 'package:flutter/src/widgets/focus_manager.dart';
import 'package:flutter/src/widgets/focus_scope.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/modal_barrier.dart';
import 'package:flutter/src/widgets/navigator.dart';
import 'package:flutter/src/widgets/overlay.dart';
import 'package:flutter/src/widgets/page_storage.dart';
import 'package:flutter/src/widgets/transitions.dart';


///把自己能处理的类注册到分发器中
Map<String, MXFunctionInvoke> registerRoutesSeries() {
  var m = <String, MXFunctionInvoke>{};
  m[_localHistoryEntry.funName] = _localHistoryEntry;
  m[_routeObserver.funName] = _routeObserver;
  return m;
}
var _localHistoryEntry = MXFunctionInvoke(
    "LocalHistoryEntry",
    (
      {
      dynamic onRemove,
      }
    ) =>
      LocalHistoryEntry(
      onRemove: createVoidCallbackClosure(_localHistoryEntry.buildOwner, onRemove),
    ),
);
var _routeObserver = MXFunctionInvoke(
    "RouteObserver",
    (
    ) =>
      RouteObserver(
    ),
);
