// Copyright 2016 The Fuchsia Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file

/// Represents a Spotify Image Object
class MusicImage {
  /// Height of image
  final double height;

  /// Widget of image
  final double width;

  // Source URL of image
  final String url;

  /// Constructor
  MusicImage({
    this.height,
    this.width,
    this.url,
  });

  /// Creates a MusicImage object from json data
  factory MusicImage.fromJson(dynamic json) {
    return new MusicImage(
      height: double.parse(json['height']),
      width: double.parse(json['width']),
      url: json['url'],
    );
  }
}
