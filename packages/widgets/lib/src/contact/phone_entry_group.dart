// Copyright 2016 The Fuchsia Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:models/contact.dart';

import 'type_defs.dart';

/// A widget representing a contact group of phone entries (phone numbers)
class PhoneEntryGroup extends StatelessWidget {
  /// List of phone entries show
  final Contact contact;

  /// Callback for when a phone entry is selected
  final PhoneActionCallback onSelectPhoneEntry;

  /// Constructor
  PhoneEntryGroup({
    Key key,
    @required this.contact,
    this.onSelectPhoneEntry,
  })
      : super(key: key) {
    assert(contact != null);
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    List<Widget> children = <Widget>[];
    contact.phoneNumbers.forEach((PhoneEntry entry) {
      children.add(new SinglePhoneEntry(
        entry: entry,
        showPrimaryStar: entry == contact.primaryPhoneNumber &&
            contact.phoneNumbers.length > 1,
        theme: theme,
      ));
    });
    return new Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        new Container(
          margin: const EdgeInsets.symmetric(
            horizontal: 24.0,
            vertical: 4.0,
          ),
          child: new Icon(
            Icons.phone,
            color: theme.primaryColor,
          ),
        ),
        new Container(
          constraints: new BoxConstraints(maxWidth: 300.0),
          child: new Column(children: children),
        ),
      ],
    );
  }
}

class SinglePhoneEntry extends StatefulWidget{
  PhoneEntry entry;
  bool showPrimaryStar;
  ThemeData theme;
  VoidCallback onTap;

  SinglePhoneEntry({
    this.entry,
    this.showPrimaryStar: false,
    this.theme,
    this.onTap,
  });

  @override
  _SinglePhoneEntryState createState() => new _SinglePhoneEntryState();
}

class _SinglePhoneEntryState extends State<SinglePhoneEntry> {
  bool _showSuggestions = false;

  @override
  Widget build(BuildContext context) {
    List<Widget> children = <Widget>[];

    // Add label if it exists for given entry
    // If not, just add an empty container for spacing
    children.add(new Container(
      width: 60.0,
      margin: const EdgeInsets.only(right: 8.0),
      child: new Text(
        config.entry.label ?? '',
        softWrap: false,
        overflow: TextOverflow.ellipsis,
        style: new TextStyle(
          color: Colors.grey[500],
          fontSize: 16.0,
        ),
      ),
    ));

    // Add actual phone number
    children.add(new Flexible(
      flex: 1,
      child: new Text(
        config.entry.number,
        softWrap: false,
        overflow: TextOverflow.ellipsis,
        style: new TextStyle(
          fontSize: 16.0,
        ),
      ),
    ));

    children.add(new Container(
      width: 50.0,
      height: 24.0,
      child: config.showPrimaryStar
          ? new Icon(
              Icons.star,
              color: config.theme.primaryColor,
            )
          : null,
    ));

    Widget suggestions = new Container(
      // TODO(dayang): Hacky, should not set size here
      width: 300.0,
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: new Column(
        children: <Widget>[
          new InlineSuggestion(
            color: Colors.blue[400],
            name: 'Call with Google Voice Dialer',
            icon: Icons.phone_in_talk
          ),
          new InlineSuggestion(
            color: Colors.green[400],
            name: 'Text with Facebook Messenger',
            icon: Icons.chat,
          ),
          new InlineSuggestion(
            color: Colors.red[400],
            name: 'Ping with YO',
            icon: Icons.announcement,
          )
        ],
      ),
    );


    return new Column(
      children: <Widget>[
        new InkWell(
          onTap: config.onTap,
          onLongPress: () {
            setState(() {
              _showSuggestions = !_showSuggestions;
            });
          },
          child: new Container(
            padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
            child: new Row(
              children: children,
            ),
          ),
        ),
        new AnimatedCrossFade(
          firstChild: new Container(height: 0.0),
          secondChild: suggestions,
          firstCurve: new Interval(0.0, 0.6, curve: Curves.fastOutSlowIn),
          secondCurve: new Interval(0.4, 1.0, curve: Curves.fastOutSlowIn),
          sizeCurve: Curves.fastOutSlowIn,
          crossFadeState: _showSuggestions ? CrossFadeState.showSecond : CrossFadeState.showFirst,
          duration: new Duration(milliseconds: 200),
        )
      ],
    );
  }
}


class InlineSuggestion extends StatelessWidget {
  String name;
  Color color;
  IconData icon;

  InlineSuggestion({
    this.name,
    this.color,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return new Container(
      height: 50.0,
      margin: const EdgeInsets.symmetric(vertical: 4.0),
      decoration: new BoxDecoration(
        backgroundColor: Colors.white,
        borderRadius: new BorderRadius.all(
          new Radius.circular(6.0),
        ),
        border: new Border.all(
          color: Colors.grey[300],
          width: 1.0,
        ),
      ),
      child: new Row(
        children: <Widget>[
          new Container(
            width: 50.0,
            height: 50.0,
            decoration: new BoxDecoration(
              backgroundColor: color,
            ),
            child: new Center(
              child: new Icon(icon, color: Colors.white),
            ),
          ),
          new Container(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            height: 50.0,
            child: new Align(
              alignment: FractionalOffset.centerLeft,
              child: new Text(
                name,
                style: new TextStyle(
                  color: Colors.grey[700],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
