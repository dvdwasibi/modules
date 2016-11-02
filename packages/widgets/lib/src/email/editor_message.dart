// Copyright 2016 The Fuchsia Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

/// Email Message Editor
/// Users can:
///   Add/Remove recipients (to, cc, bcc)
///   Edit Subject line
///   Edit Message Content
class EditorMessage extends StatefulWidget {

  /// Subject line of message
  /// ex. "WFH Today"
  String subject;

  /// Content of message
  /// ex. "Need to do laundry and ..."
  String messageContent;
}
