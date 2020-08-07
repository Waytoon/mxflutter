//  MXFlutterFramework
//  Copyright 2019 The MXFlutter Authors. All rights reserved.
//
//  Use of this source code is governed by a MIT-style license that can be
//  found in the LICENSE file.

import 'package:mxflutter/src/mirror/mx_mirror.dart';
import 'package:flutter/src/widgets/table.dart';
import 'dart:collection';
import 'package:flutter/foundation.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/src/widgets/basic.dart';
import 'package:flutter/src/widgets/debug.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/image.dart';


///把自己能处理的类注册到分发器中
Map<String, MXFunctionInvoke> registerTableSeries() {
  var m = <String, MXFunctionInvoke>{};
  m[_tableRow.funName] = _tableRow;
  m[_table.funName] = _table;
  m[_tableCell.funName] = _tableCell;
  return m;
}
var _tableRow = MXFunctionInvoke(
    "TableRow",
    (
      {
      LocalKey key,
      Decoration decoration,
      List<Widget> children,
      }
    ) =>
      TableRow(
      key: key,
      decoration: decoration,
      children: children,
    ),
);
var _table = MXFunctionInvoke(
    "Table",
    (
      {
      Key key,
      List<TableRow> children,
      Map<int, TableColumnWidth> columnWidths,
      TableColumnWidth defaultColumnWidth,
      TextDirection textDirection,
      TableBorder border,
      TableCellVerticalAlignment defaultVerticalAlignment = TableCellVerticalAlignment.top,
      TextBaseline textBaseline,
      }
    ) =>
      Table(
      key: key,
      children: children,
      columnWidths: columnWidths,
      defaultColumnWidth: defaultColumnWidth,
      textDirection: textDirection,
      border: border,
      defaultVerticalAlignment: defaultVerticalAlignment,
      textBaseline: textBaseline,
    ),
);
var _tableCell = MXFunctionInvoke(
    "TableCell",
    (
      {
      Key key,
      TableCellVerticalAlignment verticalAlignment,
      Widget child,
      }
    ) =>
      TableCell(
      key: key,
      verticalAlignment: verticalAlignment,
      child: child,
    ),
);
