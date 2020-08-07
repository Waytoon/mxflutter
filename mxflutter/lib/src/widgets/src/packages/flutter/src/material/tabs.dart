//  MXFlutterFramework
//  Copyright 2019 The MXFlutter Authors. All rights reserved.
//
//  Use of this source code is governed by a MIT-style license that can be
//  found in the LICENSE file.

import 'package:mxflutter/src/mirror/mx_mirror.dart';
import 'package:flutter/src/material/tabs.dart';
import 'dart:async';
import 'dart:ui';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/src/material/app_bar.dart';
import 'package:flutter/src/material/colors.dart';
import 'package:flutter/src/material/constants.dart';
import 'package:flutter/src/material/debug.dart';
import 'package:flutter/src/material/ink_well.dart';
import 'package:flutter/src/material/material.dart';
import 'package:flutter/src/material/material_localizations.dart';
import 'package:flutter/src/material/tab_bar_theme.dart';
import 'package:flutter/src/material/tab_controller.dart';
import 'package:flutter/src/material/tab_indicator.dart';
import 'package:flutter/src/material/theme.dart';


///把自己能处理的类注册到分发器中
Map<String, MXFunctionInvoke> registerTabsSeries() {
  var m = <String, MXFunctionInvoke>{};
  m[_tabBarIndicatorSize.funName] = _tabBarIndicatorSize;
  m[_tab.funName] = _tab;
  m[_tabBar.funName] = _tabBar;
  m[_tabBarView.funName] = _tabBarView;
  m[_tabPageSelectorIndicator.funName] = _tabPageSelectorIndicator;
  m[_tabPageSelector.funName] = _tabPageSelector;
  return m;
}
var _tabBarIndicatorSize = MXFunctionInvoke(
    "TabBarIndicatorSize",
    ({Map args}) => MXTabBarIndicatorSize.parse(args),
  );
var _tab = MXFunctionInvoke(
    "Tab",
    (
      {
      Key key,
      String text,
      Widget icon,
      EdgeInsetsGeometry iconMargin,
      Widget child,
      }
    ) =>
      Tab(
      key: key,
      text: text,
      icon: icon,
      iconMargin: iconMargin,
      child: child,
    ),
);
var _tabBar = MXFunctionInvoke(
    "TabBar",
    (
      {
      Key key,
      List<Widget> tabs,
      TabController controller,
      bool isScrollable = false,
      Color indicatorColor,
      dynamic indicatorWeight = 2.0,
      EdgeInsetsGeometry indicatorPadding,
      Decoration indicator,
      TabBarIndicatorSize indicatorSize,
      Color labelColor,
      TextStyle labelStyle,
      EdgeInsetsGeometry labelPadding,
      Color unselectedLabelColor,
      TextStyle unselectedLabelStyle,
      DragStartBehavior dragStartBehavior = DragStartBehavior.start,
      dynamic onTap,
      }
    ) =>
      TabBar(
      key: key,
      tabs: tabs,
      controller: controller,
      isScrollable: isScrollable,
      indicatorColor: indicatorColor,
      indicatorWeight: indicatorWeight?.toDouble(),
      indicatorPadding: indicatorPadding,
      indicator: indicator,
      indicatorSize: indicatorSize,
      labelColor: labelColor,
      labelStyle: labelStyle,
      labelPadding: labelPadding,
      unselectedLabelColor: unselectedLabelColor,
      unselectedLabelStyle: unselectedLabelStyle,
      dragStartBehavior: dragStartBehavior,
      onTap: createValueChangedGenericClosure<int>(_tabBar.buildOwner, onTap),
    ),
);
var _tabBarView = MXFunctionInvoke(
    "TabBarView",
    (
      {
      Key key,
      List<Widget> children,
      TabController controller,
      ScrollPhysics physics,
      DragStartBehavior dragStartBehavior = DragStartBehavior.start,
      }
    ) =>
      TabBarView(
      key: key,
      children: children,
      controller: controller,
      physics: physics,
      dragStartBehavior: dragStartBehavior,
    ),
);
var _tabPageSelectorIndicator = MXFunctionInvoke(
    "TabPageSelectorIndicator",
    (
      {
      Key key,
      Color backgroundColor,
      Color borderColor,
      dynamic size,
      }
    ) =>
      TabPageSelectorIndicator(
      key: key,
      backgroundColor: backgroundColor,
      borderColor: borderColor,
      size: size?.toDouble(),
    ),
);
var _tabPageSelector = MXFunctionInvoke(
    "TabPageSelector",
    (
      {
      Key key,
      TabController controller,
      dynamic indicatorSize = 12.0,
      Color color,
      Color selectedColor,
      }
    ) =>
      TabPageSelector(
      key: key,
      controller: controller,
      indicatorSize: indicatorSize?.toDouble(),
      color: color,
      selectedColor: selectedColor,
    ),
);
class MXTabBarIndicatorSize {
  static Map str2VMap = {
    'TabBarIndicatorSize.tab': TabBarIndicatorSize.tab,
    'TabBarIndicatorSize.label': TabBarIndicatorSize.label,
  };
  static TabBarIndicatorSize parse(dynamic value) {
    if (value is Map) {
      var valueStr = value["_name"].trim();
      var v = str2VMap[valueStr];
      return v;
    } else {
      return value;
    }
  }
}
