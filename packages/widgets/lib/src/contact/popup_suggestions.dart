// Copyright 2016 The Fuchsia Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';

/// Route for a "system-level" popup suggestion
class PopupSuggestionRoute<T> extends PopupRoute<T> {

  /// Constructor
  PopupSuggestionRoute({
    this.position,
  });

  /// Position of where to show the popup
  final RelativeRect position;

  @override
  Animation<double> createAnimation() {
    return new CurvedAnimation(
      parent: super.createAnimation(),
      curve: Curves.linear,
      // TODO(dayang): try to figure out what is going on here
      reverseCurve: new Interval(0.0, 2.0/3.0),
    );
  }

  // Setting color to null will make barrier transparent
  @override
  Color get barrierColor => null;

  @override
  Duration get transitionDuration => new Duration(milliseconds: 300);

  // Touching the (transparent) barrier will
  @override
  bool get barrierDismissable => true;

  @override
  Widget buildPage(
    BuildContext context,
    Animation<double> animation,
    Animation<double> forwardAnimation,
  ) {
    // Do something here and position the stuff
    return new Container(
      width: 100.0,
      height: 100.0,
      decoration: new BoxDecoration(
        backgroundColor: Colors.white,
      ),
    );
  }
}

/// Shows the suggestion overlay
void showSuggestions({
  BuildContext context,
}) {
  // TODO(dayang): use position to do stuff
  Navigator.push(context, new PopupSuggestionRoute<dynamic>());
}
