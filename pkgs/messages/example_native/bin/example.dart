// Copyright (c) 2023, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:example/testarbctx2.g.dart';
import 'package:messages/intl.dart';

Future<void> main(List<String> arguments) async {
  var name = 'Bill';
  var country = 'India';

  /// This is the Intl.message mode. These calls can be extracted into an .arb
  /// file, making it necessary to associate each call with an ID to relate them
  /// to the proto messages.
  ///
  // print(intl.message(
  //   r'Hello $1 and welcome to $2',
  //   args: [name, country],
  //   description: 'Saying hello by first name',
  // ));
  // intl.initWithProto(deMessages);
  // print(intl.message(r'Hello $1 and welcome to $2', args: [name, country]));
  // intl.initWithProto(enMessages);
  // print(intl.message(r'testertester', args: ['female', 'Nadja', 'Bob', 1]));
  // print(intl.message(r'testertester', args: ['male', 'Peter', 'Bob', 1]));

  /// This is the autogenerated message mode; starting from an .arb file,
  /// generate a file containing the named methods. This makes an ID field
  /// unnecessary, as they relate to the proto by index, fixed during the build
  /// step.
  ///
  /// If wanting to use both modes, the ID's must be generated, which should be
  /// an argument? What should the default be?
  ///
  ///TODO have methods which belong to the class look differently than message methods
  print('#Get through Intl.message, but without instantiating');

  // var loadFromLibStrategy = (id) => File('lib/$id').readAsBytesSync();
  var myMessagesAbout = AboutPageMessages();
  print('About message en:');
  myMessagesAbout.loadLocale('en');
  myMessagesAbout.aboutMessage('mywebsite.com');
  print('About message fr:');
  myMessagesAbout.loadLocale('fr');
  print(myMessagesAbout.aboutMessage('mywebsite.com'));

  myMessagesAbout.helloAndWelcome('Peter', 'Pan');
  // OLD WAY
  print('#Get through Intl.message');
  print(Intl.message(
    'Hello #0 and welcom to #1',
    args: [name, country],
    id: 'helloAndWelcome',
  ));
  // myMessagesAbout.currentLocale = 'de';

  // print('#Get by id');
  // print(myMessages.getById(
  //   'helloAndWelcome',
  //   [name, country],
  // ));

  // print('#Get by enum');
  // print(myMessages
  //     .getByEnum(HomePageMessagesEnum.helloAndWelcome, [name, country]));
  // print('#Get by index');
  // print(myMessages.getByIndex(MessagesIndex.helloAndWelcome, [name, country]));
  // myMessages.currentLocale = 'de';
  // print('#Call with de');
  // print(myMessages.helloAndWelcome(name, country));
  // myMessages.currentLocale = 'en';
  // print('#Call with en');
  // print(myMessages.helloAndWelcome(name, country));

  print('#Show that messages can be different in different locales');
  // print(Messages.withen().helloAndWelcome('male', 0.toString()));
  // print(Messages.withen().newMessages2('female', 0.toString()));
  // print(Messages.withde().newMessages2('male', 0.toString()));
}
