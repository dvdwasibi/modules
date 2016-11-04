// Copyright 2016 The Fuchsia Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';
import 'dart:convert' show JSON;

import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:flutter/http.dart' as http;
import 'package:models/youtube.dart';

/// Duration between switching thumbnails to fake video playing effect
final Duration _kSlideDuration = const Duration(milliseconds: 300);

/// Duration after which the Play Overlay will autohide
final Duration _kOverlayAutoHideDuration = const Duration(seconds: 1);

final String _kApiBaseUrl = 'https://content.googleapis.com';

final String _kApiRestOfUrl = '/youtube/v3/videos';

final String _kApiQueryParts = 'contentDetails,snippet,statistics';

/// [YoutubePlayer] is a [StatelessWidget]
/// UI Widget that can "play" Youtube videos.
///
/// Since there is no video support for Flutter, this widget just shows a
/// slideshow of thumbnails for the video.
/// TODO(dayang): Get Youtube Video Metadata (name, playcount, likes) from
/// the Youtube API
/// https://fuchsia.atlassian.net/browse/SO-109
class YoutubePlayer extends StatefulWidget {
  /// ID for given youtube video
  final String videoId;

  /// Youtube API key needed to access the Youtube Public APIs
  final String apiKey;

  /// Constructor
  YoutubePlayer({
    Key key,
    @required this.videoId,
    @required this.apiKey,
  })
      : super(key: key) {
    assert(videoId != null);
    assert(apiKey != null);
  }

  @override
  _YoutubePlayerState createState() => new _YoutubePlayerState();
}

class _YoutubePlayerState extends State<YoutubePlayer> {
  /// Flag for whether the video is playing or not
  bool _playing = false;

  /// Flag for whether the play-button overlay is showing on top of the video
  bool _showingPlayOverlay = true;

  /// Flag for whether video data (name, viewcount...) is being retrieved
  bool _loadingVideoData = true;

  /// Flag for if the video data fails to load
  bool _videoDataLoadFailure = false;

  /// Track the current thumbnail that is being shown
  /// Youtube provides 4 thumbnails (0,1,2,3)
  int _thumbnailIndex = 0;

  /// Track the current timer showing the slideshow
  Timer _currentTimer;

  /// Data for given video
  VideoData _videoData;

  @override
  void initState() {
    super.initState();
    print('Call Me');
    // Load up Video Metadata
    _getVideoData().then((VideoData videoData) {
      print(videoData);
      if(videoData == null) {
        setState(() {
          _loadingVideoData = false;
          _videoDataLoadFailure = true;
        });
      } else {
        setState(() {
          _loadingVideoData = false;
          _videoData = videoData;
        });
      }
    }).catchError((Error error) {
      print(error);
    });
  }

  Future<VideoData> _getVideoData() async {
    Map<String, String> params = <String, String>{};
    params['id'] = config.videoId;
    params['key'] = config.apiKey;
    params['part'] = _kApiQueryParts;

    Uri uri = new Uri.https(_kApiBaseUrl, _kApiRestOfUrl, params);
    http.Response response = await http.get(uri);
    dynamic jsonData = JSON.decode(response.body);

    if(response.statusCode != 200) {
      return null;
    }

    if(jsonData['items'] is List<Map<String, dynamic>> && jsonData['items'].isNotEmpty) {
      return new VideoData.fromJson(jsonData['items'][0]);
    } else {
      return null;
    }
  }

  /// Show the play-button overlay on top of the video
  /// The play overlay will auto-hide after 1 second if the video is currently
  /// playing.
  void _showPlayOverlay() {
    if (mounted) {
      setState(() {
        _showingPlayOverlay = true;
      });
      new Timer(_kOverlayAutoHideDuration, () {
        setState(() {
          if (_playing) {
            _showingPlayOverlay = false;
          }
        });
      });
    }
  }

  /// Toggle between playing and pausing depending on the current state
  void _togglePlay() {
    if (mounted) {
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
  }

  /// "Play" the video by starting the slideshow
  void _play() {
    if (mounted) {
      _currentTimer = new Timer.periodic(_kSlideDuration, (Timer timer) {
        setState(() {
          if (_thumbnailIndex == 3) {
            _thumbnailIndex = 0;
          } else {
            _thumbnailIndex++;
          }
        });
      });
    }
  }

  /// "Pause" the video by stopping the slideshow
  void _pause() {
    _currentTimer?.cancel();
  }

  String get _currentThumbnailURL =>
      'http://img.youtube.com/vi/${config.videoId}/$_thumbnailIndex.jpg';

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
  void dispose() {
    super.dispose();
    _currentTimer.cancel();
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
              _currentThumbnailURL,
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
