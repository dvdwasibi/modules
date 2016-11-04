// Copyright 2016 The Fuchsia Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

/// Represents Video Data from a single Youtube video
class VideoData {

  /// Title of video
  String title;

  /// Description of video
  String description;

  /// Title of channel that published the video
  String channelTitle;

  /// Time when video was published
  DateTime publishedAt;

  /// Number of times the video has been viewed
  int viewCount;

  /// Number of times the video has been liked
  int likeCount;

  /// Number of times the video has been disliked
  int dislikeCount;

  /// Constructs [VideoData] model from Youtube api json data
  VideoData.fromJson(dynamic json) {
    title = json['snippet']['title'];
    description = json['snippet']['description'];
    // TODO (dayang): Coerce to datetime format
    publishedAt = json['snippet']['publishedAt'];
    channelTitle = json['channelTitle'];
    viewCount = int.parse(json['statistics']['viewCount']);
    likeCount = int.parse(json['statistics']['likeCount']);
    dislikeCount = int.parse(json['statistics']['dislikeCount']);
  }
}
