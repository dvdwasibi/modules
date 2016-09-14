// Copyright 2016 The Fuchsia Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'message.dart';

/// Represents a single Gmail Thread
/// https://developers.google.com/gmail/api/v1/reference/users/threads#resource
class Thread {
  /// The unique ID of the thread (provided by Gmail)
  String id;

  /// A short part of the message text (provided by Gmail)
  String snippet;

  /// The ID of the last history record that modified this thread (provided by Gmail)
  String historyId;

  /// The list of messages in the thread (provided by Gmail)
  List<Message> messages;

  /// Constructor
  Thread({
    this.id,
    this.snippet,
    this.historyId,
    this.messages,
  });
}
