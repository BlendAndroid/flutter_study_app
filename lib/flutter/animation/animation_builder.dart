import 'package:flutter/material.dart';

void main() => runApp(MaterialApp(
      home: HomePage(),
    ));

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  Animation<double>? _doubleAnim;
  AnimationController? _animationController;

  //监听
  void myListener(status) {
    if (status == AnimationStatus.completed) {
      //将监听移除掉
      _doubleAnim?.removeStatusListener(myListener);
      // _animationController?.removeStatusListener(myListener);
      _animationController?.reset();
      //Curve：定义了时间和数值的抽象类。Flutter封装定义了一系列的插值器，
      // 如linear、decelerate、ease、bounce、cubic等。当然Flutter提供的不满足需求的话，也可以自定义插值器。
      //Tween：线性估值器
      _doubleAnim = Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(
          parent: _animationController!, curve: Curves.fastOutSlowIn));
      _animationController?.forward();
    }
  }

  @override
  void initState() {
    super.initState();
    _animationController =
        AnimationController(vsync: this, duration: const Duration(seconds: 2));
    _doubleAnim = Tween(begin: -1.0, end: 0.0).animate(CurvedAnimation(
        parent: _animationController!, curve: Curves.fastOutSlowIn))
      ..addStatusListener(myListener);
    _animationController?.forward();
  }

  @override
  void dispose() {
    super.dispose();
    _animationController?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //屏幕宽度
    var _screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: AnimatedBuilder(
          animation: _animationController!,
          builder: (BuildContext context, Widget? child) {
            return Transform(
              transform: Matrix4.translationValues(
                  (_doubleAnim?.value ?? 0) * _screenWidth, 0.0, 0.0),
              child: Center(
                child: Container(
                  width: 200.0,
                  height: 200.0,
                  child: FlutterLogo(),
                ),
              ),
            );
          }),
    );
  }
}
