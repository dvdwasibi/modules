// Copyright 2016 The Fuchsia Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

enum PixelColor{
  black,
  silver,
  blue,
}

class InteractiveReceipt extends StatefulWidget {

  InteractiveReceipt({
    Key key,
  }) : super(key: key);

  @override
  _InteractiveReceiptState createState() => new _InteractiveReceiptState();
}

class _InteractiveReceiptState extends State<InteractiveReceipt> with TickerProviderStateMixin {

  _InteractiveReceiptState() : super();

  AnimationController _controller;

  bool _editMode = false;

  String _storageSize = '32 GB';

  PixelColor _selectedPixelColor = PixelColor.silver;

  @override
  void initState() {
    super.initState();
    _controller = new AnimationController(vsync: this);
  }

  String get price {
    if(_storageSize == '32 GB') {
      return '\$769.00';
    } else {
      return '\$869.00';
    }
  }

  String get imageUrl {
    switch(_selectedPixelColor) {
      case PixelColor.black:
        return 'https://www.androidcentral.com/sites/androidcentral.com/files/styles/larger/public/article_images/2016/10/rendered-pixel-black-front-2.png?itok=PcwNz917';
      case PixelColor.silver:
        return 'https://www.androidcentral.com/sites/androidcentral.com/files/styles/larger/public/article_images/2016/10/rendered-pixel-silver.png?itok=qQduu9rZ';
      case PixelColor.blue:
        return 'https://www.androidcentral.com/sites/androidcentral.com/files/styles/larger/public/article_images/2016/10/rendered-pixel-blue.png?itok=ilI-D_u3';
    }
  }

  String get _colorText{
    switch(_selectedPixelColor) {
      case PixelColor.black:
        return 'Quite Black';
      case PixelColor.silver:
        return 'Very Silver';
      case PixelColor.blue:
        return 'Really Blue';
    }
  }

  Color _getColorFromPixelColor(PixelColor pixelColor) {
    switch(pixelColor) {
      case PixelColor.blue:
        return Colors.blue[600];
      case PixelColor.silver:
        return Colors.white;
      case PixelColor.black:
        return Colors.black;
    }
  }

  Widget _buildBrandHeader() {
    return new Container(
      height: 130.0,
      padding: const EdgeInsets.only(top: 24.0),
      alignment: FractionalOffset.topCenter,
      decoration: new BoxDecoration(
        backgroundColor: Colors.grey[800],
      ),
      // Add Google Store thing Here
      child: new Text(
        'Google Store',
        style: new TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w500,
          fontSize: 24.0,
        ),
      ),
    );
  }

  Widget _buildColorSelection(PixelColor pixelColor) {
    return new Container(
      margin: const EdgeInsets.symmetric(horizontal: 4.0),
      decoration: new BoxDecoration(
        border: _selectedPixelColor == pixelColor ?
          new Border.all(color: Colors.grey[600], width: 3.0) :
          new Border.all(color: Colors.grey[300]),
      ),
      child: new Material(
        color: _getColorFromPixelColor(pixelColor),
        child: new InkWell(
          onTap: () {
            setState(() {
              _selectedPixelColor = pixelColor;
            });
          },
          child: new Container(
            width: 30.0,
            height: 30.0,
          ),
        ),
      ),
    );
  }

  Widget _buildPixelData() {
      if(_editMode) {
        return new Flexible(
          flex: 1,
          child: new Column(
            children: <Widget>[
              new Row(
                children: <Widget>[
                  _buildColorSelection(PixelColor.black),
                  _buildColorSelection(PixelColor.blue),
                  _buildColorSelection(PixelColor.silver),
                ],
              ),
            ],
          ),
        );
      } else {
        return new Flexible(
          flex: 1,
          child: new Text(
            '$_storageSize / $_colorText',
          ),
        );
      }
  }

  Widget _buildSizing() {

  }

  Widget _buildPixelListing() {
    return new Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        new AnimatedSize(
          child: new Image.network(
            imageUrl,
            height: _editMode ? 150.0 : 100.0,
            width: _editMode ? 150.0 : 100.0,
            fit: ImageFit.contain,
            gaplessPlayback: true,
          ),
          duration: new Duration(milliseconds: 500),
          curve: Curves.easeInOut,
          vsync: this,
        ),
        new Flexible(
          flex: 1,
          child: new Container(
            margin: const EdgeInsets.only(top: 30.0),
            child: new Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                new Text(
                  '1 Pixel XL',
                  style: new TextStyle(
                    fontSize: 18.0,
                  ),
                ),
                new Container(
                  margin: const EdgeInsets.only(
                    top: 4.0,
                    right: 24.0,
                  ),
                  child: new Row(
                    children: <Widget>[
                      _buildPixelData(),
                      new Text(price),
                    ],
                  ),
                ),
                _editMode ? new DropdownButton<String>(
                  value: _storageSize,
                  onChanged: (String newValue) {
                    setState(() {
                      if (newValue != null)
                        _storageSize = newValue;
                    });
                  },
                  items: <String>['32 GB', '128 GB'].map((String value) {
                    return new DropdownMenuItem<String>(
                      value: value,
                      child: new Text(value),
                    );
                  }).toList(),
                ) : new Container(),
                _editMode ? new Container(
                  child: new FlatButton(
                    child: new Text(
                      'DONE',
                      style: new TextStyle(
                        color: Colors.blue[600],
                      ),
                    ),
                    onPressed: () {
                      setState(() {
                        _editMode = false;
                      });
                    }
                  )
                ) : new Container(),
              ],
            ),
          ),
        ),
        new Container(
          margin: const EdgeInsets.only(
            right: 16.0,
            left: 16.0,
            top: 30.0,
          ),
          child: new IconButton(
            onPressed: (){
              setState(() {
                _editMode = !_editMode;
              });
            },
            icon: new Icon(Icons.edit),
            color: _editMode ? Colors.white : Colors.blue[600],
          ),
        ),
      ],
    );
  }

  Widget _buildPricingTotal() {
    return new Container(
      margin: const EdgeInsets.only(
        left: 64.0,
        right: 64.0,
        top: 16.0,
      ),
      padding: const EdgeInsets.only(
        top: 16.0,
        left: 28.0,
        right: 28.0,
      ),
      decoration: new BoxDecoration(
        border: new Border(top: new BorderSide(
          color: Colors.grey[300],
        )),
      ),
      child: new Column(
        children: <Widget>[
          new Container(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: new Row(
            children: <Widget>[
              new Flexible(
                flex: 1,
                child: new Text('Subtotal'),
              ),
              new Text(price),
            ]
          ),
        ),
          new Container(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: new Row(
            children: <Widget>[
              new Flexible(
                flex: 1,
                child: new Text('Shipping & Handling'),
              ),
              new Text('\$0.00'),
            ]
          ),
        ),
          new Container(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: new Row(
            children: <Widget>[
              new Flexible(
                flex: 1,
                child: new Text('Tax'),
              ),
              new Text('\$0.00'),
            ]
          ),
        ),
          new Container(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: new Row(
            children: <Widget>[
              new Flexible(
                flex: 1,
                child: new Text('Total'),
              ),
              new Text(price),
            ]
          ),
        ),
        ]
      ),
    );
  }

  Widget _buildMainItemCard() {
    return new Container(
      padding: const EdgeInsets.only(
        top: 70.0,
        right: 48.0,
        left: 48.0,
      ),
      child: new Card(
        elevation: 2,
        child: new Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            new Row(
              children: <Widget>[
                new Flexible(
                  flex: 1,
                  child: new Container(
                    alignment: FractionalOffset.center,
                    decoration: new BoxDecoration(
                      backgroundColor: Colors.grey[300],
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 36.0),
                    child: new Text(
                      'Thanks for shopping with Google',
                      style: new TextStyle(
                        fontSize: 20.0,
                        color: Colors.grey[700],
                      ),
                    ),
                  ),
                ),

              ],
            ),
            new Container(
              padding: const EdgeInsets.all(16.0),
              child: new Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  _buildPixelListing(),
                  _buildPricingTotal(),
                ]
              ),
            ),
          ],
        ),
      )
    );
  }


  @override
  Widget build(BuildContext context) {
    return new Stack(
      alignment: FractionalOffset.topLeft,
      children: <Widget>[
        _buildBrandHeader(),
        _buildMainItemCard(),
      ]
    );
  }
}
