// Copyright (c) 2023, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:io';
import 'dart:typed_data';

import 'package:messages_serializer/messages_serializer.dart';

class MessageShrinker {
  String shrink(String fileName, List<int> messagesToKeep) {
    var newFileName = '$fileName.shrnk';
    var file = File(fileName);
    var newFile = File(newFileName);
    if (fileName.endsWith('.carb.dart')) {
      var buffer = file.readAsStringSync();
      var jsonExtracted = extractJsonFromClass(buffer);
      var newBuffer = shrinkJson(jsonExtracted, messagesToKeep);
      newFile.writeAsString(newBuffer);
    } else if (fileName.endsWith('.carb')) {
      var bytes = file.readAsBytesSync();
      var newBytes = shrinkNative(bytes, messagesToKeep);
      newFile.writeAsBytes(newBytes);
    } else {
      throw ArgumentError('Not a valid Message file');
    }
    return file.path;
  }

  String shrinkJson(String buffer, List<int> messagesToKeep) {
    var messageList = WebDeserializer(buffer).deserialize();
    return WebSerializer(messageList.hasIds)
        .serialize(
          messageList.hash,
          messageList.locale,
          messagesToKeep.map((index) => messageList.messages[index]).toList(),
        )
        .data;
  }

  Uint8List shrinkNative(Uint8List bytes, List<int> messagesToKeep) {
    var messageList = NativeDeserializer(bytes).deserialize();
    return NativeSerializer(messageList.hasIds)
        .serialize(
          messageList.hash,
          messageList.locale,
          messagesToKeep.map((index) => messageList.messages[index]).toList(),
        )
        .data;
  }
}

String extractJsonFromClass(String buffer) {
  var jsonStart = buffer.indexOf('r\'');
  var jsonEnd = buffer.lastIndexOf('\';');
  return buffer.substring(jsonStart + 2, jsonEnd);
}
