//  MXFlutterFramework
//  Copyright 2019 The MXFlutter Authors. All rights reserved.
//
//  Use of this source code is governed by a MIT-style license that can be
//  found in the LICENSE file.

import 'package:mxflutter/src/mirror/mx_mirror.dart';
import 'package:flutter/src/widgets/focus_traversal.dart';
import 'dart:ui';
import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/src/widgets/actions.dart';
import 'package:flutter/src/widgets/basic.dart';
import 'package:flutter/src/widgets/editable_text.dart';
import 'package:flutter/src/widgets/focus_manager.dart';
import 'package:flutter/src/widgets/focus_scope.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/scroll_position.dart';
import 'package:flutter/src/widgets/scrollable.dart';

///把自己能处理的类注册到分发器中
Map<String, MXFunctionInvoke> registerFocusTraversalSeries() {
  var m = <String, MXFunctionInvoke>{};
  m[_traversalDirection.funName] = _traversalDirection;
  m[_widgetOrderTraversalPolicy.funName] = _widgetOrderTraversalPolicy;
  m[_readingOrderTraversalPolicy.funName] = _readingOrderTraversalPolicy;
  m[_numericFocusOrder.funName] = _numericFocusOrder;
  m[_lexicalFocusOrder.funName] = _lexicalFocusOrder;
  m[_orderedTraversalPolicy.funName] = _orderedTraversalPolicy;
  m[_focusTraversalOrder.funName] = _focusTraversalOrder;
  m[_focusTraversalGroup.funName] = _focusTraversalGroup;
  m[_requestFocusAction.funName] = _requestFocusAction;
  m[_requestFocusActionKey.funName] = _requestFocusActionKey;
  m[_nextFocusAction.funName] = _nextFocusAction;
  m[_nextFocusActionKey.funName] = _nextFocusActionKey;
  m[_previousFocusAction.funName] = _previousFocusAction;
  m[_previousFocusActionKey.funName] = _previousFocusActionKey;
  m[_directionalFocusIntent.funName] = _directionalFocusIntent;
  m[_directionalFocusAction.funName] = _directionalFocusAction;
  m[_directionalFocusActionKey.funName] = _directionalFocusActionKey;
  return m;
}

var _traversalDirection = MXFunctionInvoke(
    "TraversalDirection",
    ({String name, int index}) => MXTraversalDirection.parse(name, index),
    ["name", "index"]);
var _widgetOrderTraversalPolicy = MXFunctionInvoke(
  "WidgetOrderTraversalPolicy",
  () => WidgetOrderTraversalPolicy(),
  [],
);
var _readingOrderTraversalPolicy = MXFunctionInvoke(
  "ReadingOrderTraversalPolicy",
  () => ReadingOrderTraversalPolicy(),
  [],
);
var _numericFocusOrder = MXFunctionInvoke(
  "NumericFocusOrder",
  ({
    dynamic order,
  }) =>
      NumericFocusOrder(
    order?.toDouble(),
  ),
  [
    "order",
  ],
);
var _lexicalFocusOrder = MXFunctionInvoke(
  "LexicalFocusOrder",
  ({
    String order,
  }) =>
      LexicalFocusOrder(
    order,
  ),
  [
    "order",
  ],
);
var _orderedTraversalPolicy = MXFunctionInvoke(
  "OrderedTraversalPolicy",
  ({
    FocusTraversalPolicy secondary,
  }) =>
      OrderedTraversalPolicy(
    secondary: secondary,
  ),
  [
    "secondary",
  ],
);
var _focusTraversalOrder = MXFunctionInvoke(
  "FocusTraversalOrder",
  ({
    Key key,
    FocusOrder order,
    Widget child,
  }) =>
      FocusTraversalOrder(
    key: key,
    order: order,
    child: child,
  ),
  [
    "key",
    "order",
    "child",
  ],
);
var _focusTraversalGroup = MXFunctionInvoke(
  "FocusTraversalGroup",
  ({
    Key key,
    FocusTraversalPolicy policy,
    Widget child,
  }) =>
      FocusTraversalGroup(
    key: key,
    policy: policy,
    child: child,
  ),
  [
    "key",
    "policy",
    "child",
  ],
);
var _requestFocusAction = MXFunctionInvoke(
  "RequestFocusAction",
  () => RequestFocusAction(),
  [],
);
var _requestFocusActionKey =
    MXFunctionInvoke("RequestFocusAction.key", () => RequestFocusAction.key);
var _nextFocusAction = MXFunctionInvoke(
  "NextFocusAction",
  () => NextFocusAction(),
  [],
);
var _nextFocusActionKey =
    MXFunctionInvoke("NextFocusAction.key", () => NextFocusAction.key);
var _previousFocusAction = MXFunctionInvoke(
  "PreviousFocusAction",
  () => PreviousFocusAction(),
  [],
);
var _previousFocusActionKey =
    MXFunctionInvoke("PreviousFocusAction.key", () => PreviousFocusAction.key);
var _directionalFocusIntent = MXFunctionInvoke(
  "DirectionalFocusIntent",
  ({
    TraversalDirection direction,
    bool ignoreTextFields = true,
  }) =>
      DirectionalFocusIntent(
    direction,
    ignoreTextFields: ignoreTextFields,
  ),
  [
    "direction",
    "ignoreTextFields",
  ],
);
var _directionalFocusAction = MXFunctionInvoke(
  "DirectionalFocusAction",
  () => DirectionalFocusAction(),
  [],
);
var _directionalFocusActionKey = MXFunctionInvoke(
    "DirectionalFocusAction.key", () => DirectionalFocusAction.key);

class MXTraversalDirection {
  static TraversalDirection parse(String name, int index) {
    switch (name) {
      case 'TraversalDirection.up':
        return TraversalDirection.up;
      case 'TraversalDirection.right':
        return TraversalDirection.right;
      case 'TraversalDirection.down':
        return TraversalDirection.down;
      case 'TraversalDirection.left':
        return TraversalDirection.left;
    }
    return null;
  }
}