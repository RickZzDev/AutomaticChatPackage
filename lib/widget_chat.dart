import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ChatAnimatedMessage extends StatefulWidget {
  String message;
  Color baloonColor;
  BorderRadius roundedBorder;
  int timeToStart;

  ChatAnimatedMessage(
      {this.message, this.baloonColor, this.timeToStart, this.roundedBorder});

  @override
  _ChatAnimatedMessageState createState() => _ChatAnimatedMessageState();
}

class _ChatAnimatedMessageState extends State<ChatAnimatedMessage>
    with TickerProviderStateMixin {
  // Color secondaryColor = Singleton().secondaryColor;
  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 18.0);
  AnimationController _breathingController;

  double _breathe = 0.0;
  double _breathe2 = 0.0;
  double _breathe3 = 0.0;

  double opacityBall1 = 1;
  double opacityBall2 = 0.8;
  double opacityBall3 = 0.6;

  String message2 = "";
  int index = 0;
  bool _typing = true;

  @override
  void initState() {
    // TODO: implement initState
    animFunction();
    Timer(
        Duration(milliseconds: widget.timeToStart),
        () => {
              setState(() {
                _typing = false;
              }),
              sendTextToBallon()
            });
    super.initState();
  }

  @override
  void dispose() {
    if (_breathingController.status == AnimationStatus.forward ||
        _breathingController.status == AnimationStatus.reverse) {
      _breathingController.notifyStatusListeners(AnimationStatus.dismissed);
    }
    _breathingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = 15.0 - 5.0 * _breathe;
    final size2 = 13.0 - 5.0 * _breathe2;
    final size3 = 11.0 - 5.0 * _breathe3;
    return Container(
      padding: EdgeInsets.only(top: 8, bottom: 8, left: 12, right: 24),
      // alignment: Alignment.centerRight,
      constraints:
          BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.7),
      child: Container(
        // constraints: BoxConstraints(maxWidth: 250),
        padding: EdgeInsets.only(
          top: 17,
          bottom: 17,
          right: 10,
          left: 15,
        ),
        decoration: BoxDecoration(
            borderRadius: widget.roundedBorder,

            //  BorderRadius.only(
            //     // topLeft: Radius.circular(23),
            //     bottomLeft: Radius.circular(23),
            //     topRight: Radius.circular(23),
            //     bottomRight: Radius.circular(23)),
            gradient: _typing
                ? LinearGradient(colors: [Colors.grey, Colors.grey])
                : LinearGradient(
                    colors: [widget.baloonColor, widget.baloonColor])),
        child: _typing
            ? Row(
                children: <Widget>[
                  Container(
                    height: size,
                    width: size,
                    margin: EdgeInsets.only(right: 3),
                    decoration: BoxDecoration(
                        color: Colors.black.withOpacity(opacityBall1),
                        borderRadius: BorderRadius.circular(10)),
                  ),
                  Container(
                    height: size2,
                    width: size2,
                    margin: EdgeInsets.only(right: 3),
                    decoration: BoxDecoration(
                        color: Colors.black.withOpacity(opacityBall2),
                        borderRadius: BorderRadius.circular(10)),
                  ),
                  Container(
                    height: size3,
                    width: size3,
                    decoration: BoxDecoration(
                        color: Colors.black.withOpacity(opacityBall3),
                        borderRadius: BorderRadius.circular(10)),
                  )
                ],
              )
            : Text(message2,
                textAlign: TextAlign.start,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontFamily: "",
                    fontWeight: FontWeight.w500)),
      ),
    );
  }

  void animFunction() {
    _breathingController = AnimationController(
        vsync: this, duration: Duration(milliseconds: 1000));
    if (mounted) {
      _breathingController.addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          mounted ? _breathingController.reverse() : null;
          // setState(() {
          //   count = count + 1;
          // });
        } else if (status == AnimationStatus.dismissed) {
          mounted ? _breathingController.forward() : null;
        } else {}
      });
    } else {
      _breathingController.removeStatusListener((status) {});
    }

    _breathingController.addListener(() {
      Timer(
          Duration(milliseconds: 1),
          () => {
                mounted
                    ? setState(() {
                        _breathe = _breathingController.value - 0.30;
                        opacityBall1 = _breathingController.value;
                      })
                    : null
              });
      Timer(
          Duration(milliseconds: 5),
          () => {
                mounted
                    ? setState(() {
                        _breathe2 = _breathingController.value - 0.10;
                        opacityBall2 = _breathingController.value;
                      })
                    : null
              });
      Timer(
          Duration(milliseconds: 8),
          () => {
                mounted
                    ? setState(() {
                        _breathe3 = _breathingController.value;
                        opacityBall3 = _breathingController.value;
                      })
                    : null
              });
    });
    mounted ? _breathingController.forward() : null;
  }

  void sendTextToBallon() {
    mounted
        ? setState(() {
            message2 += widget.message[index];
            index = index + 1;
          })
        : null;
    index < widget.message.length
        ? Timer(Duration(milliseconds: 50), () => sendTextToBallon())
        : null;
  }
}
