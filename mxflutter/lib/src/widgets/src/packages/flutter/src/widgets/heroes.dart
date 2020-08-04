//  MXFlutterFramework
//  Copyright 2019 The MXFlutter Authors. All rights reserved.
//
//  Use of this source code is governed by a MIT-style license that can be
//  found in the LICENSE file.

import 'package:mxflutter/src/mirror/mx_mirror.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/heroes.dart';


class MXProxyHeroes {
  ///把自己能处理的类注册到分发器中
  static Map<String, MXFunctionInvoke> registerSeries() {
    var m = <String, MXFunctionInvoke>{};
    m[heroFlightDirection.funName] = heroFlightDirection;
    m[hero.funName] = hero;
    m[heroController.funName] = heroController;
    return m;
  }
  static var heroFlightDirection = MXFunctionInvoke(
      "HeroFlightDirection",
      ({Map args}) => MXHeroFlightDirection.parse(args),
  );
  static var hero = MXFunctionInvoke(
      "Hero",
      ({
        Key key,
        Object tag,
        dynamic createRectTween,
        dynamic flightShuttleBuilder,
        dynamic placeholderBuilder,
        bool transitionOnUserGestures = false,
        Widget child,
      }) =>
        Hero(
        key: key,
        tag: tag,
        createRectTween: createRectTween,
        flightShuttleBuilder: flightShuttleBuilder,
        placeholderBuilder: placeholderBuilder,
        transitionOnUserGestures: transitionOnUserGestures,
        child: child,
      ),
    );
  static var heroController = MXFunctionInvoke(
      "HeroController",
      ({
        dynamic createRectTween,
      }) =>
        HeroController(
        createRectTween: createRectTween,
      ),
    );
}
class MXHeroFlightDirection {
  static Map str2VMap = {
    'HeroFlightDirection.push': HeroFlightDirection.push,
    'HeroFlightDirection.pop': HeroFlightDirection.pop,
  };
  static HeroFlightDirection parse(dynamic value) {
    if (value is Map) {
      var valueStr = value["_name"].trim();
      var v = str2VMap[valueStr];
      return v;
    } else {
      return value;
    }
  }
}
