// Copyright 2016 The Fuchsia Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

import 'package:models/email.dart';

/// Email Message Editor
/// Users can:
///   Add/Remove recipients (to, cc)
///   Edit Subject line
///   Edit Message Content
class EditorMessage extends StatefulWidget {

  /// The message that is being composed
  /// This is where the information such as the recipients, subject and message
  /// content will be saved
  Message message;

  /// Constructor
  EditorMessage({
    Key key,
    @required this.message,
  }) : super(key: key) {
    assert(message != null);
  }

  @override
  _EditorMessageState createState() => new _EditorMessageState();
}


class _EditorMessageState extends State<EditorMessage> {

  @override
  void initState() {
    super.initState();
    config.message.recipientList ??= <Mailbox>[];
    config.message.ccList ??= <Mailbox>[];
    config.message.subject ??= '';
  }

  @override
  Widget build(BuildContext context) {
    return new Container();
  }
}
