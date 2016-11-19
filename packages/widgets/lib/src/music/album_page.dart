// Copyright 2016 The Fuchsia Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:clients/music_client.dart';
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
    MusicClient.getAlbumById(config.albumId)
      .then((Album album) {
        if(mounted) {
          if(album == null) {
            setState(() {
              _loadingState = LoadingState.failed;
            });
          } else {
            setState(() {
              _loadingState = LoadingState.completed;
              _album = album;
            });
          }
        }
      }).catchError((_) {
        if(mounted) {
          setState(() {
            _loadingState = LoadingState.failed;
          });
        }
      });
  }

  Widget _buildTrackListItem({
    Track track,
    int count,
  }) {
    return new Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 8.0,
        vertical: 16.0,
      ),
      child: new Row(
        children: <Widget>[
          new Container(
            margin: const EdgeInsets.only(right: 16.0),
            child: new Icon(
              Icons.play_circle_outline,
              color: Colors.grey[300],
            ),
          ),
          new Container(
            margin: const EdgeInsets.only(right: 16.0),
            child: new Text(
              '$count',
              style: new TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          new Text(
            track.name,
          ),
        ],
      ),
    );
  }

  Widget _buildTrackList() {
    List<Widget> children = <Widget>[];
    children.add(new Container(
      margin: const EdgeInsets.only(bottom: 24.0),
      child: new Text(
        'TRACK LISTING',
        style: new TextStyle(
          color: Colors.pink[500],
        ),
      ),
    ));

    int trackCount = 1;
    _album.tracks.forEach((Track track) {
      children.add(_buildTrackListItem(
        track: track,
        count: trackCount,
      ));
      trackCount++;
    });

    return new Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: children,
    );
  }

  Widget _buildPage() {
    // 3 Rows
    return new Row();
  }

  @override
  Widget build(BuildContext context) {
    Widget page;
    switch (_loadingState) {
      case LoadingState.inProgress:
        page = new Container(
          height: 100.0,
          child: new Center(
            child: new CircularProgressIndicator(
              value: null,
              valueColor: new AlwaysStoppedAnimation<Color>(Colors.grey[300]),
            ),
          ),
        );
        break;
      case LoadingState.completed:
        // Something goes here
        page = new Container();
        break;
      case LoadingState.failed:
        page = new Container(
          height: 100.0,
          child: new Text('Content Failed to Load'),
        );
        break;
    }
    return page;
  }
}
