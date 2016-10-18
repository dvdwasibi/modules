// Copyright 2016 The Fuchsia Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:module_toolkit/modular_widget.dart';
import 'package:module_toolkit/module_capability.dart';
import 'package:module_toolkit/module_data.dart';

/// Represents a module that can play Youtube videos.
///
/// Since there is no video support for Flutter, this widget just shows a
/// slideshow of thumbnails for the video.
class YoutubePlayer extends StatefulWidget {
  /// Youtube video ID of specific video
  String videoId;

  /// Constructor
  YoutubePlayer({
    Key key,
    @required this.videoId,
  })
      : super(key: key) {
    assert(videoId != null);
  }

  @override
  _YoutubePlayerState createState() => new _YoutubePlayerState();
}

class _YoutubePlayerState extends State<YoutubePlayer> {
  /// Flag for whether the video is playing or not
  bool _playing = false;

  /// The play overlay that extends
  bool _showingPlayOverlay = true;

  /// Track the current thumbnail that is being shown
  /// Youtube provides 4 thumbnails (0,1,2,3)
  int _thumbnailIndex = 0;
  Timer _currentTimer;

  final Duration _kSlideDuration = const Duration(milliseconds: 300);

  void _showPlayOverlay() {
    setState(() {
      _showingPlayOverlay = true;
    });
    new Timer(const Duration(seconds: 1), () {
      setState(() {
        if (_playing) {
          _showingPlayOverlay = false;
        }
      });
    });
  }

  void _togglePlay() {
    setState(() {
      _playing = !_playing;
      if (_playing) {
        _play();
        _showingPlayOverlay = false;
      } else {
        _pause();
      }
    });
  }

  void _play() {
    _currentTimer = new Timer(_kSlideDuration, () {
      setState(() {
        if (_thumbnailIndex == 3) {
          _thumbnailIndex = 0;
        } else {
          _thumbnailIndex++;
        }
      });
      _play();
    });
  }

  void _pause() {
    if (_currentTimer != null && _currentTimer.isActive) {
      _currentTimer.cancel();
    }
  }

  String _getCurrentThumbnailURL() {
    return 'http://img.youtube.com/vi/${config.videoId}/$_thumbnailIndex.jpg';
  }

  /// Overlay widget that contains playback controls
  Widget _buildControlOverlay() {
    return new Container(
      decoration: new BoxDecoration(
        gradient: new RadialGradient(
          center: FractionalOffset.center,
          colors: <Color>[
            const Color.fromARGB(30, 0, 0, 0),
            const Color.fromARGB(200, 0, 0, 0),
            const Color.fromARGB(200, 0, 0, 0),
          ],
          stops: <double>[
            0.0,
            0.7,
            1.0,
          ],
          radius: 1.0,
        ),
      ),
      child: new Material(
        color: const Color.fromRGBO(0, 0, 0, 0.0),
        child: new Center(
          child: new IconButton(
            icon: _playing ? new Icon(Icons.pause) : new Icon(Icons.play_arrow),
            size: 60.0,
            onPressed: _togglePlay,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Container(
      width: 250.0,
      height: 250.0,
      child: new Stack(
        children: <Widget>[
          new InkWell(
            onTap: _showPlayOverlay,
            child: new Image.network(
              _getCurrentThumbnailURL(),
              gaplessPlayback: true,
              fit: ImageFit.cover,
              width: 250.0,
              height: 250.0,
            ),
          ),
          new Offstage(
            offstage: !_showingPlayOverlay,
            child: _buildControlOverlay(),
          ),
        ],
      ),
    );
  }
}

/// ModularWidgetBuilder for the YoutubePlayer
class YoutubePlayerBuilder extends ModularWidgetBuilder {
  /// Constructor
  YoutubePlayerBuilder();

  @override
  Widget buildWidget(ModuleData data) {
    return new YoutubePlayer(
      videoId: data.payload.content,
    );
  }

  @override
  BoxConstraints get boxConstraints => new BoxConstraints(
        minWidth: 200.0,
        minHeight: 200.0,
      );

  @override
  List<ModuleCapability> get desiredCapabilities => <ModuleCapability>[
        ModuleCapability.network,
        ModuleCapability.click,
        ModuleCapability.audio,
        ModuleCapability.video,
      ];
}
