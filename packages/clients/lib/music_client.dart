// Copyright 2016 The Fuchsia Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';
import 'dart:convert' show JSON;

import 'package:flutter/http.dart' as http;
import 'package:models/music.dart';

const String _kApiBaseUrl = 'api.spotify.com';
const String _kAlbumBaseUrl = '/v1/albums/';

/// Client to retrieve data for Music
class MusicClient {

  /// Retrieves the given album based on id
  static Future<Album> getAlbumById(String id) async {
    Uri uri = new Uri.https(_kApiBaseUrl, _kAlbumBaseUrl + id);
    http.Response response = await http.get(uri);
    if (response.statusCode != 200) {
      return null;
    }
    dynamic jsonData = JSON.decode(response.body);
    return new Album.fromFullJson(jsonData);
  }
}
