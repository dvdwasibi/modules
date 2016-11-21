// Copyright 2016 The Fuchsia Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';

enum _PixelColor{
  black,
  silver,
  blue,
}

enum _StorageSize{
  s32,
  s128,
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
  Animation<double> _imageAnimation;

  bool _editMode = false;

  _StorageSize _storageSize = _StorageSize.s32;

  _PixelColor _selectedPixelColor = _PixelColor.silver;

  @override
  void initState() {
    super.initState();
    _controller = new AnimationController(
      duration: new Duration(milliseconds: 300),
      vsync: this
    );
    _imageAnimation = _initAnimation(Curves.ease, false);
  }

  Animation<double> _initAnimation(Curve curve, bool inverted) {
    final CurvedAnimation animation = new CurvedAnimation(
      parent: _controller,
      curve: curve
    );

    return inverted ? new Tween<double>(
      begin: 2.0,
      end: 1.0,
    ).animate(animation) : new Tween<double>(
      begin: 1.0,
      end: 2.0,
    ).animate(animation);
  }

  String get storageSizeText {
    switch(_storageSize) {
      case _StorageSize.s32:
        return '32 GB';
      case _StorageSize.s128:
        return '128 GB';
    }
  }

  String get price {
    switch(_storageSize) {
      case _StorageSize.s32:
        return '\$769.00';
      case _StorageSize.s128:
        return '\$869.00';
    }
  }

  String get imageUrl {
    switch(_selectedPixelColor) {
      case _PixelColor.black:
        return 'https://lh3.googleusercontent.com/WiZ9IdoWExc2vUdR5Oom31lK3BNHeaZ8SRFLgSUl2ObTYineH7LPKLM5NbHaAGXZt0qf';
      case _PixelColor.silver:
        return 'https://lh3.googleusercontent.com/JKkKltrLkFnpNirTEjb8yA5bui0Hv7mPocx8T5Gu6qUiYrlnt1Jcx7ITH9pobnejSp9u';
      case _PixelColor.blue:
        return 'https://lh3.googleusercontent.com/7cco-0fPUfmv0D0Rk0dCDYYv1QjzncyGEhxN5zFUHKWoIKuxgvrOwAFbAyRkKxLvv6pV';
    }
  }

  String get _colorText{
    switch(_selectedPixelColor) {
      case _PixelColor.black:
        return 'Quite Black';
      case _PixelColor.silver:
        return 'Very Silver';
      case _PixelColor.blue:
        return 'Really Blue';
    }
  }

  Color _getColorFromPixelColor(_PixelColor pixelColor) {
    switch(pixelColor) {
      case _PixelColor.blue:
        return Colors.blue[600];
      case _PixelColor.silver:
        return Colors.white;
      case _PixelColor.black:
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
      // TODO(dayang): put in actual Google store LOGO
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

  Widget _buildColorOption(_PixelColor pixelColor) {
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              new Row(
                children: <Widget>[
                  _buildColorOption(_PixelColor.black),
                  _buildColorOption(_PixelColor.blue),
                  _buildColorOption(_PixelColor.silver),
                ],
              ),
              new Container(
                margin: const EdgeInsets.only(left: 4.0),
                child: new DropdownButton<_StorageSize>(
                  value: _storageSize,
                  onChanged: (_StorageSize newSize) {
                    setState(() {
                      if (newSize != null)
                        _storageSize = newSize;
                    });
                  },
                  items: <_StorageSize>[_StorageSize.s32,_StorageSize.s128].map((_StorageSize value) {
                    String text;
                    switch(value) {
                      case _StorageSize.s32:
                        text = '32 GB';
                        break;
                      case _StorageSize.s128:
                        text = '128 GB';
                        break;
                    };
                    return new DropdownMenuItem<_StorageSize>(
                      value: value,
                      child: new Text(text),
                    );
                  }).toList(),
                ),
              ),
              new Container(
                margin: const EdgeInsets.only(top: 4.0),
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
                      _controller.reverse();
                    });
                  }
                ),
              ),
            ],
          ),
        );
      } else {
        return new Flexible(
          flex: 1,
          child: new Text(
            '$storageSizeText / $_colorText',
            softWrap: false,
            overflow: TextOverflow.fade,
          ),
        );
      }
  }

  Widget _buildPixelListing() {
    return new Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        new _AnimatedPixelImage(
          imageUrl: imageUrl,
          animation: _imageAnimation,
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
                      _editMode ? new Container() : new Text(price),
                    ],
                  ),
                ),
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
                _controller.forward();
              });
            },
            icon: new Icon(Icons.edit),
            color: _editMode ? Colors.white : Colors.blue[600],
          ),
        ),
      ],
    );
  }

  Widget _buildPricingSection({String label, String value}) {
    return new Container(
    padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: new Row(
        children: <Widget>[
          new Flexible(
            flex: 1,
            child: new Text(label),
          ),
          new Text(value),
        ]
      ),
    );
  }

  Widget _buildPricing() {
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
          _buildPricingSection(
            label: 'Subtotal',
            value: price,
          ),
          _buildPricingSection(
            label: 'Shipping & Handling',
            value: '\$0.00',
          ),
          _buildPricingSection(
            label: 'Tax',
            value: '\$0.00',
          ),
          _buildPricingSection(
            label: 'Total',
            value: price,
          ),
        ],
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
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  _buildPixelListing(),
                  _buildPricing(),
                ]
              ),
            ),
          ],
        ),
      )
    );
  }

  Widget _buildUpSellItem({
    String name,
    String price,
    String imageUrl,
  }) {
    return new Container(
      margin: const EdgeInsets.all(16.0),
      child: new Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          new Container(
            margin: const EdgeInsets.only(bottom: 4.0),
            padding: const EdgeInsets.all(15.0),
            width: 225.0,
            height: 225.0,
            decoration: new BoxDecoration(
              backgroundColor: Colors.grey[300],
            ),
            child: new Image.network(
              imageUrl,
            ),
          ),
          new Text(
            name,
            style: new TextStyle(height: 1.5),
          ),
          new Text(
            price,
            style: new TextStyle(
              height: 1.5,
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUpSell() {
    return new Container(
      decoration: new BoxDecoration(
        backgroundColor: Colors.white,
      ),
      child: new Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          new Container(
            alignment: FractionalOffset.center,
            padding: const EdgeInsets.only(top: 32.0, bottom: 12.0),
            child: new Text(
              'YOU MAY ALSO LIKE',
              style: new TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.w400,
                color: Colors.grey[600],
              ),
            ),
          ),
          new Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              _buildUpSellItem(
                name: 'Chromecast Ultra',
                price: '\$69',
                imageUrl: 'https://lh3.googleusercontent.com/yq9EWTGMYrpcav3_0ROrNYMA3IC5EJuvpZxNOiEsfMk7dunDdWR2TP_S-Khu1WGejQ',
              ),
              _buildUpSellItem(
                name: 'Google Home',
                price: '\$129',
                imageUrl: 'https://lh3.googleusercontent.com/Nu3a6F80WfixUqf_ec_vgXy_c0-0r4VLJRXjVFF_X_CIilEu8B9fT35qyTEj_PEsKw',
              ),
            ]
          ),
          new Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              _buildUpSellItem(
                name: 'Artworks Live Case',
                price: '\$40',
                imageUrl: 'https://lh3.googleusercontent.com/aYJf9JJIwsNXO_W-1GKBPtdrcfplqzVKUCBUj5sWNJX5jECg3ku68aP0HbgLecEL8A',
              ),
              _buildUpSellItem(
                name: 'Daydrem View',
                price: '\$79',
                imageUrl: 'https://lh3.googleusercontent.com/3cTyu0he1Yv6YkDFcsyQURR3H0kQsk0IB8raKeWxtTK_NsngsgnVP5XOLW4cuT9FLME',
              ),
            ]
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Block(
      children: <Widget>[
        new Container(
          decoration: new BoxDecoration(
            backgroundColor: Colors.grey[100],
          ),
          padding: const EdgeInsets.only(bottom: 32.0),
          child: new Stack(
            alignment: FractionalOffset.topLeft,
            children: <Widget>[
              _buildBrandHeader(),
              _buildMainItemCard(),
            ]
          ),
        ),
        _buildUpSell(),
      ],
    );

  }
}

class _AnimatedPixelImage extends AnimatedWidget{

  final String imageUrl;

  _AnimatedPixelImage({
    Key key,
    Animation<double> animation,
    this.imageUrl,
  }) : super(key: key, animation: animation);

  @override
  Widget build(BuildContext context) {
    return new Container(
      height: 100.0 * animation.value,
      width: 100.0 * animation.value,
      child: new Image.network(
        imageUrl,
        gaplessPlayback: true,
      ),
    );
  }
}
