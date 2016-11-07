// Copyright 2016 The Fuchsia Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';
import 'dart:convert' show JSON;

import 'package:flutter/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:meta/meta.dart';
import 'package:models/youtube.dart';

import '../user/alphatar.dart';

final String _kApiBaseUrl = 'content.googleapis.com';

final String _kApiRestOfUrl = '/youtube/v3/videos';

final String _kApiQueryParts = 'contentDetails,snippet,statistics';

/// Represents the state of data loading
enum LoadingState {
  /// Still fetching data
  inProgress,
  /// Data has completed loading
  completed,
  /// Data failed to load
  failed,
}

/// UI Widget that loads and shows the basic information about a Youtube
/// video such as: title, likes, channel title, description...
class YoutubeVideoHeader extends StatefulWidget {

  /// ID for given youtube video
  final String videoId;


  /// Youtube API key needed to access the Youtube Public APIs
  final String apiKey;

  /// Constructor
  YoutubeVideoHeader({
    Key key,
    @required this.videoId,
    @required this.apiKey,
  }) : super(key: key) {
    assert(videoId != null);
    assert(apiKey != null);
  }

  @override
  _YoutubeVideoHeaderState createState() => new _YoutubeVideoHeaderState();
}

class _YoutubeVideoHeaderState extends State<YoutubeVideoHeader> {

  /// Data for given video
  VideoData _videoData;

  /// Loading State for video data (name, viewcount...)
  LoadingState _loadingState = LoadingState.inProgress;

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


  @override
  void initState() {
    super.initState();
    // Load up Video Metadata
    _getVideoData().then((VideoData videoData) {
      if(mounted) {
        if(videoData == null) {
          setState(() {
            _loadingState = LoadingState.failed;
          });
        } else {
          setState(() {
            _loadingState = LoadingState.completed;
            _videoData = videoData;
          });
        }
      }
    }).catchError((dynamic stuff) {
      if(mounted) {
        setState(() {
          _loadingState = LoadingState.failed;
        });
      }
    });
  }

  Widget _buildLikeCount() {
    return new Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        new Container(
          padding: const EdgeInsets.only(right:4.0),
          child: new Icon(
            Icons.thumb_up,
            color: Colors.grey[500],
          ),
        ),
        new Text(
          new NumberFormat.compact().format(_videoData.likeCount),
          style: new TextStyle(color: Colors.grey[500]),
        ),
        new Container(
          padding: const EdgeInsets.only(
            left: 16.0,
            right:4.0,
          ),
          child: new Icon(
            Icons.thumb_down,
            color: Colors.grey[500],
          ),
        ),
        new Text(
          new NumberFormat.compact().format(_videoData.dislikeCount),
          style: new TextStyle(color: Colors.grey[500]),
        ),
      ],
    );
  }

  Widget _buildPrimaryHeader() {
    return new Container(
      padding: const EdgeInsets.all(16.0),
      decoration: new BoxDecoration(
        border: new Border(
          bottom: new BorderSide(
            color: Colors.grey[300],
            width: 1.0,
          ),
        ),
      ),
      child: new Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          // Title
          new Text(
            _videoData.title,
            style: new TextStyle(
              fontSize: 18.0,
            ),
          ),
          // ViewCount
          new Container(
            padding: const EdgeInsets.symmetric(vertical: 12.0),
            child: new Text(
              '${new NumberFormat.decimalPattern().format(_videoData.viewCount)}'
              ' views',
              style: new TextStyle(
                color: Colors.grey[500],
              ),
            ),
          ),
          // Likes :) & Dislikes :(
          _buildLikeCount(),
        ],
      ),
    );
  }

  Widget _buildChannelHeader() {
    return new Container(
      padding: const EdgeInsets.all(16.0),
      decoration: new BoxDecoration(
        border: new Border(
          bottom: new BorderSide(
            color: Colors.grey[300],
            width: 1.0,
          ),
        ),
      ),
      child: new Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          new Row(
            children: <Widget>[
              new Alphatar(
                size: 40.0,
                letter: _videoData.channelTitle[0],
              ),
              new Container(
                padding: const EdgeInsets.only(left: 8.0),
                child: new Text(
                  _videoData.channelTitle,
                ),
              ),
            ],
          ),
          new FlatButton(
            child: new Row(
              children: <Widget>[
                new Container(
                  padding: const EdgeInsets.only(right: 4.0),
                  child: new Icon(
                    Icons.ondemand_video,
                    color: Colors.red[600],
                    size: 20.0,
                  ),
                ),
                new Text(
                  'SUBSCRIBE',
                  style: new TextStyle(
                    fontWeight: FontWeight.w500,
                    color: Colors.red[600],
                  ),
                ),
              ]
            ),
            onPressed: (){}, //This is mock and face
          ),
        ]
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget header;
    switch (_loadingState) {
      case LoadingState.inProgress:
        header = new Container(
          height: 50.0,
          child: new Center(
            child: new CircularProgressIndicator(
              value: null,
              valueColor: new AlwaysStoppedAnimation<Color>(Colors.grey[300]),
            ),
          ),
        );
        break;
      case LoadingState.completed:
        header = new Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _buildPrimaryHeader(),
            _buildChannelHeader(),
          ],
        );
        break;
      case LoadingState.failed:
        header = new Container(
          height: 50.0,
          child: new Text('Content Failed to Load'),
        );
        break;
    }
    return header;
  }
}
