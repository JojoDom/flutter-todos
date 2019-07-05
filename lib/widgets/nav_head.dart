import 'dart:math';

import 'package:flutter/material.dart';

class NavHead extends StatefulWidget {
  @override
  _NavHeadState createState() => _NavHeadState();
}

class _NavHeadState extends State<NavHead> with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation _animation;

  @override
  void initState() {
    _controller =
        AnimationController(vsync: this, duration: Duration(seconds: 60));
    _animation = Tween(begin: 0.0, end: 1.0).animate(_controller);
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        debugPrint("动画完成");
        _controller.reset();
        _controller.forward();
      }
    });
    _controller.forward();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final double navHeaderHeight = size.height / 4;
    final double circleOneRadius = navHeaderHeight / 4;
    final double circleTwoRadius = navHeaderHeight / 8;
    final double circleThreeRadius = navHeaderHeight / 7;
    final double circleFourRadius = navHeaderHeight / 5;
    final double circleFiveRadius = navHeaderHeight / 2;

    return Container(
      height: navHeaderHeight,
      decoration: BoxDecoration(
          gradient: LinearGradient(colors: [
        Theme.of(context).primaryColorDark,
        Theme.of(context).primaryColor,
        Colors.white.withOpacity(0.6),
      ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
      child: Stack(
        children: <Widget>[
          Stack(
            children: getRain(navHeaderHeight, context),
          ),
          Positioned(
            child: getCircle(context, circleOneRadius),
            left: -circleOneRadius,
            top: 10,
          ),
          Positioned(
            child: getCircle(context, circleTwoRadius),
            left: circleOneRadius + circleTwoRadius,
            top: circleTwoRadius,
          ),
          Positioned(
            child: getCircle(context, circleThreeRadius),
            left: circleOneRadius + circleTwoRadius * 2 + circleThreeRadius * 2,
            top: 0,
          ),
          Positioned(
            child: getCircle(context, circleFourRadius),
            left: circleOneRadius + circleTwoRadius + circleThreeRadius,
            top: navHeaderHeight - circleFourRadius * 5 / 3,
          ),
          Positioned(
            child: getCircle(context, circleFiveRadius),
            left: circleOneRadius +
                circleTwoRadius +
                circleThreeRadius +
                circleFiveRadius,
            bottom: -50,
          ),
        ],
      ),
    );
  }

  Widget getCircle(BuildContext context, double circleOneRadius) {
    final angle = getRandomAngle();
    final randomPosOrNeg = Random().nextBool() == true ? 1 : -1;
    return AnimatedBuilder(
      builder: (ctx, child) {
        return Transform.rotate(
          angle: angle * _animation.value * randomPosOrNeg,
          child: child,
        );
      },
      animation: _animation,
      child: Container(
        decoration: getDecoration(context, circleOneRadius),
        width: circleOneRadius * 2,
        height: circleOneRadius * 2,
      ),
    );
  }

  BoxDecoration getDecoration(BuildContext context, double circleOneRadius) {
    return BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(colors: getRandomColor(context)),
        boxShadow: [
          getBackShadow(circleOneRadius),
        ]);
  }

  BoxShadow getBackShadow(double circleOneRadius) {
    return BoxShadow(
      offset: Offset(0.0, circleOneRadius / 2),
      color: Colors.black.withOpacity(0.8),
      blurRadius: circleOneRadius + 5,
      spreadRadius: -circleOneRadius / 2,
    );
  }

  List<Color> getRandomColor(BuildContext context, {int times}) {
    final List<Color> randomColorList = [
      Theme.of(context).primaryColor,
      Theme.of(context).primaryColorDark,
      Colors.white.withOpacity(0.8)
    ];
    List<Color> list = [];
    for (var i = 0; i < (times ?? randomColorList.length); ++i) {
      final randomNumber = Random().nextInt(randomColorList.length);
      list.add(randomColorList[randomNumber]);
    }
    if (list.contains(Colors.white.withOpacity(0.8))) {
      list.add(Theme.of(context).primaryColor);
      list.add(Theme.of(context).primaryColorDark);
    } else {
      list.insert(Random().nextInt(randomColorList.length),
          Colors.white.withOpacity(0.8));
    }
    return list;
  }

  double getRandomAngle() {
    final randomNumberOne = Random().nextInt(10);
    final randomPosOrNeg = Random().nextBool() == true ? 1 : -1;
    final randomNumberTwo = Random().nextDouble();
    return pi * 2 +
        randomNumberOne * (pi * 2) +
        (pi * 2) * randomPosOrNeg * randomNumberTwo;
  }

  List<Widget> getRain(double navHeaderHeight, BuildContext context) {
    final randomNum = Random().nextInt(20) + 1;

    List<Widget> list = List.generate(randomNum, (index) {
      final randomWidth = Random().nextDouble() * 10;
      final randomHeight = Random().nextDouble() * 30;
      final randomL = Random().nextDouble() * navHeaderHeight;
      final randomT = Random().nextDouble() * navHeaderHeight;
      return AnimatedBuilder(
        animation: _animation,
        builder: (ctx, child) {
          return Positioned(
            child: child,
            left: randomL - navHeaderHeight * _animation.value,
            top: randomT + navHeaderHeight * _animation.value,
          );
        },
        child: Transform.rotate(
          angle: pi / 6,
          child: Container(
            width: randomWidth,
            height: randomHeight,
            decoration: BoxDecoration(
                borderRadius:
                    BorderRadius.all(Radius.circular(randomWidth / 2)),
                gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Theme.of(context).primaryColor, Colors.white])),
          ),
        ),
      );
    });
    return list;
  }
}
