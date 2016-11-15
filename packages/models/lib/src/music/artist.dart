// Copyright 2016 The Fuchsia Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file

enum RepresentationType {
  full,
  simplified,
}

/// Represents a Musical Artist
class Artist {

  /// The name of the artist
  final String name;

  /// Images of the artist in various sizes
  final List<String> images;

  /// List of genres the artist is associated with
  final List<String> genres;

  /// Spotify ID of artist
  final String id;

  final RepresentationType representation;

  /// Constructor
  Artist({
    this.name,
    this.images,
    this.genres,
    this.id,
    this.representation: RepresentationType.full,
  });

  /// Create a full artist object from json data
  factory Artist.fromFullJson(dynamic json) {

    // List<
    // if(json['images'] is List<dynamic)) {
    //
    // }
    return new Artist(
      name: json['name'],
      images: json['images'], //TODO
      genres: json['genres'], //TODO
      id: json['id'],
      representation: RepresentationType.full,
    );
  }

  /// Create a simplified artist object from json data
  factory Artist.fromSimplifiedJson(dynamic json) {
    return new Artist(
      name: json['name'],
      id: json['id'],
      representation: RepresentationType.simplified,
    );
  }
}
