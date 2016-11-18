// Copyright 2016 The Fuchsia Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:models/music.dart';

import 'loading_state.dart';

/// UI Widget that represents the overview page of an album
class AlbumPage extends StatefulWidget {

  /// Spotify Id of given album
  final String albumId;

  AlbumPage({
    Key key,
    @required this.albumId,
  }) : super(key: key) {
    assert(albumId != null);
  }

  @override
  _AlbumPageState createState() => new _AlbumPageState();
}

class _AlbumPageState extends State<AlbumPage> {

  /// Album after it has loaded
  Album _album;

  /// Loading State for Album data
  LoadingState _loadingState = LoadingState.inProgress;

  @override
  void initState() {
    super.initState();
    // MAKE RETREIVAL
  }

  @override
  Widget build(BuildContext context) {
    return new Container();
  }
}
