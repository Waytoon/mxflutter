//  MXFlutterFramework
//  Copyright 2019 The MXFlutter Authors. All rights reserved.
//
//  Use of this source code is governed by a MIT-style license that can be
//  found in the LICENSE file.

import 'package:mxflutter/src/mirror/mx_mirror.dart';
import 'package:flutter/src/material/ink_well.dart';
import 'dart:collection';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/src/material/debug.dart';
import 'package:flutter/src/material/feedback.dart';
import 'package:flutter/src/material/ink_highlight.dart';
import 'package:flutter/src/material/material.dart';
import 'package:flutter/src/material/theme.dart';


///把自己能处理的类注册到分发器中
Map<String, MXFunctionInvoke> registerInkWellSeries() {
  var m = <String, MXFunctionInvoke>{};
  m[_inkResponse.funName] = _inkResponse;
  m[_inkWell.funName] = _inkWell;
  return m;
}
var _inkResponse = MXFunctionInvoke(
    "InkResponse",
    (
      {
      Key key,
      Widget child,
      dynamic onTap,
      dynamic onTapDown,
      dynamic onTapCancel,
      dynamic onDoubleTap,
      dynamic onLongPress,
      dynamic onHighlightChanged,
      dynamic onHover,
      bool containedInkWell = false,
      BoxShape highlightShape = BoxShape.circle,
      dynamic radius,
      BorderRadius borderRadius,
      ShapeBorder customBorder,
      Color focusColor,
      Color hoverColor,
      Color highlightColor,
      Color splashColor,
      InteractiveInkFeatureFactory splashFactory,
      bool enableFeedback = true,
      bool excludeFromSemantics = false,
      FocusNode focusNode,
      bool canRequestFocus = true,
      dynamic onFocusChange,
      bool autofocus = false,
      }
    ) =>
      InkResponse(
      key: key,
      child: child,
      onTap: createVoidCallbackClosure(_inkResponse.buildOwner, onTap),
      onTapDown: createValueChangedGenericClosure<TapDownDetails>(_inkResponse.buildOwner, onTapDown),
      onTapCancel: createVoidCallbackClosure(_inkResponse.buildOwner, onTapCancel),
      onDoubleTap: createVoidCallbackClosure(_inkResponse.buildOwner, onDoubleTap),
      onLongPress: createVoidCallbackClosure(_inkResponse.buildOwner, onLongPress),
      onHighlightChanged: createValueChangedGenericClosure<bool>(_inkResponse.buildOwner, onHighlightChanged),
      onHover: createValueChangedGenericClosure<bool>(_inkResponse.buildOwner, onHover),
      containedInkWell: containedInkWell,
      highlightShape: highlightShape,
      radius: radius?.toDouble(),
      borderRadius: borderRadius,
      customBorder: customBorder,
      focusColor: focusColor,
      hoverColor: hoverColor,
      highlightColor: highlightColor,
      splashColor: splashColor,
      splashFactory: splashFactory,
      enableFeedback: enableFeedback,
      excludeFromSemantics: excludeFromSemantics,
      focusNode: focusNode,
      canRequestFocus: canRequestFocus,
      onFocusChange: createValueChangedGenericClosure<bool>(_inkResponse.buildOwner, onFocusChange),
      autofocus: autofocus,
    ),
);
var _inkWell = MXFunctionInvoke(
    "InkWell",
    (
      {
      Key key,
      Widget child,
      dynamic onTap,
      dynamic onDoubleTap,
      dynamic onLongPress,
      dynamic onTapDown,
      dynamic onTapCancel,
      dynamic onHighlightChanged,
      dynamic onHover,
      Color focusColor,
      Color hoverColor,
      Color highlightColor,
      Color splashColor,
      InteractiveInkFeatureFactory splashFactory,
      dynamic radius,
      BorderRadius borderRadius,
      ShapeBorder customBorder,
      bool enableFeedback = true,
      bool excludeFromSemantics = false,
      FocusNode focusNode,
      bool canRequestFocus = true,
      dynamic onFocusChange,
      bool autofocus = false,
      }
    ) =>
      InkWell(
      key: key,
      child: child,
      onTap: createVoidCallbackClosure(_inkWell.buildOwner, onTap),
      onDoubleTap: createVoidCallbackClosure(_inkWell.buildOwner, onDoubleTap),
      onLongPress: createVoidCallbackClosure(_inkWell.buildOwner, onLongPress),
      onTapDown: createValueChangedGenericClosure<TapDownDetails>(_inkWell.buildOwner, onTapDown),
      onTapCancel: createVoidCallbackClosure(_inkWell.buildOwner, onTapCancel),
      onHighlightChanged: createValueChangedGenericClosure<bool>(_inkWell.buildOwner, onHighlightChanged),
      onHover: createValueChangedGenericClosure<bool>(_inkWell.buildOwner, onHover),
      focusColor: focusColor,
      hoverColor: hoverColor,
      highlightColor: highlightColor,
      splashColor: splashColor,
      splashFactory: splashFactory,
      radius: radius?.toDouble(),
      borderRadius: borderRadius,
      customBorder: customBorder,
      enableFeedback: enableFeedback,
      excludeFromSemantics: excludeFromSemantics,
      focusNode: focusNode,
      canRequestFocus: canRequestFocus,
      onFocusChange: createValueChangedGenericClosure<bool>(_inkWell.buildOwner, onFocusChange),
      autofocus: autofocus,
    ),
);
