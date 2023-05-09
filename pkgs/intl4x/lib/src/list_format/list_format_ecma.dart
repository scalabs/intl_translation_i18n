// Copyright (c) 2023, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:js/js.dart';
import 'package:js/js_util.dart';

import '../locale.dart';
import '../options.dart';
import '../utils.dart';
import 'list_format.dart';
import 'list_format_options.dart';

ListFormat? getListFormatterECMA(
  List<Locale> locales,
  LocaleMatcher localeMatcher,
) =>
    _ListFormatECMA.tryToBuild(locales, localeMatcher);

@JS('Intl.ListFormat')
class ListFormatJS {
  external factory ListFormatJS([List<String> locale, Object options]);
  external String format(List<String> list);
}

@JS('Intl.ListFormat.supportedLocalesOf')
external List<String> supportedLocalesOfJS(
  List<String> listOfLocales, [
  Object options,
]);

class _ListFormatECMA extends ListFormatImpl {
  _ListFormatECMA(super.locales);

  static ListFormat? tryToBuild(
    List<Locale> locales,
    LocaleMatcher localeMatcher,
  ) {
    final supportedLocales = supportedLocalesOf(locales, localeMatcher);
    return supportedLocales.isNotEmpty
        ? ListFormat(_ListFormatECMA(supportedLocales))
        : null;
  }

  static List<String> supportedLocalesOf(
    List<String> locales,
    LocaleMatcher localeMatcher,
  ) {
    final o = newObject<Object>();
    setProperty(o, 'localeMatcher', localeMatcher.jsName);
    return List.from(supportedLocalesOfJS(localeToJs(locales), o));
  }

  @override
  String formatImpl(
    List<String> list, {
    LocaleMatcher localeMatcher = LocaleMatcher.bestfit,
    Type type = Type.conjunction,
    ListStyle style = ListStyle.long,
  }) {
    final o = newObject<Object>();
    setProperty(o, 'localeMatcher', localeMatcher.jsName);
    setProperty(o, 'type', type.name);
    setProperty(o, 'style', style.name);
    return ListFormatJS(locales, o).format(list);
  }
}
