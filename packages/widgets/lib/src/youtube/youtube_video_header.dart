// Copyright 2016 The Fuchsia Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:models/youtube.dart';

/// [YoutubeVideoHeader] is a [StatelessWidget]
class YoutubeVideoHeader extends StatelessWidget {

  /// Data for given video
  VideoData videoData;

  /// Constructor
  YoutubeVideoHeader({
    Key key,
    @required this.videoData,
  }) : super(key: key) {
    assert(videoData != null);
  }

  @override
  Widget build(BuildContext context) {
    return new Container();
  }
}
