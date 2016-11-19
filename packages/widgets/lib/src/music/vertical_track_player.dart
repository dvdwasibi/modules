// Copyright 2016 The Fuchsia Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:models/music.dart';

class VerticalTrackPlayer extends StatelessWidget {

  /// Track to play
  final Track track;

  VerticalTrackPlayer({
    Key key,
    @required this.track,
  }) : super(key: key) {
    assert(track != null);
  }

  @override
  Widget build(BuildContext context) {

  }
}
