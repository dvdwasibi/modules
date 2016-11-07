// Copyright 2016 The Fuchsia Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:meta/meta.dart';
import 'package:models/youtube.dart';

import '../user/alphatar.dart';


/// UI Widget that loads and shows the basic information about a Youtube
/// video such as: title, likes, channel title, description...
class YoutubeVideoHeader extends StatelessWidget {

  /// Data for given video
  final VideoData videoData;

  /// Constructor
  YoutubeVideoHeader({
    Key key,
    @required this.videoData,
  }) : super(key: key) {
    assert(videoData != null);
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
          new NumberFormat.compact().format(videoData.likeCount),
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
          new NumberFormat.compact().format(videoData.dislikeCount),
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
            videoData.title,
            style: new TextStyle(
              fontSize: 18.0,
            ),
          ),
          // ViewCount
          new Container(
            padding: const EdgeInsets.symmetric(vertical: 12.0),
            child: new Text(
              '${new NumberFormat.decimalPattern().format(videoData.viewCount)}'
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
                letter: videoData.channelTitle[0],
              ),
              new Container(
                padding: const EdgeInsets.only(left: 8.0),
                child: new Text(
                  videoData.channelTitle,
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
    return new Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        _buildPrimaryHeader(),
        _buildChannelHeader(),
      ],
    );
  }
}
