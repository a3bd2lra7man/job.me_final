import 'package:flutter/material.dart';
import 'package:job_me/_shared/themes/colors.dart';


class LoadingWidget extends StatelessWidget {
  const LoadingWidget({
    Key? key,
    this.progress,
  }) : super(key: key);
  final double? progress;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Loading(
          indicator: BallPulseIndicator(),
          color: AppColors.grey,
        ),
        if (progress != null) ...[
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: LinearProgressIndicator(value: progress),
          ),
        ],
      ],
    );
  }
}


class Loading extends StatefulWidget {
  final Indicator? indicator;
  final double size;
  final Color color;

  const Loading({
    Key? key,
    this.indicator,
    this.size = 50.0,
    this.color = Colors.white,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => LoadingState();
}

class LoadingState extends State<Loading> with TickerProviderStateMixin {
  Indicator? indicator;

  @override
  void initState() {
    super.initState();
    if (widget.indicator == null) {
      indicator = BallScaleIndicator();
    } else {
      indicator = widget.indicator;
    }
    indicator!.context = this;
    indicator!.start();
  }

  @override
  void dispose() {
    indicator!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _Painter(indicator, widget.color),
      size: Size.square(widget.size),
    );
  }
}

class _Painter extends CustomPainter {
  Indicator? indicator;
  Color color;
  Paint? defaultPaint;

  _Painter(this.indicator, this.color) {
    defaultPaint = Paint()
      ..strokeCap = StrokeCap.butt
      ..style = PaintingStyle.fill
      ..color = color
      ..isAntiAlias = true;
  }

  @override
  void paint(Canvas canvas, Size size) {
    indicator!.paint(canvas, defaultPaint, size);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}


class BallPulseIndicator extends Indicator {
  //scale x ,y
  List<double> scaleDoubles = [0.3, 0.3, 0.3];
  List<int> delays = [120, 120, 120];

  @override
  void paint(Canvas canvas, Paint? paint, Size size) {
    const circleSpacing = 4;
    final width = size.width;
    final height = size.height;
    final radius = width / 6;
    final x = width / 2 - (radius * 2 + circleSpacing);
    final y = height / 2;
    for (int i = 0; i < 3; i++) {
      canvas.save();
      final translateX = x + (radius * 2) * i + circleSpacing * i;
      canvas.translate(translateX, y);
      canvas.scale(scaleDoubles[i], scaleDoubles[i]);
      canvas.drawCircle(Offset.zero, radius, paint!);
      canvas.restore();
    }
  }

  @override
  List<AnimationController> animation() {
    final controllers = <AnimationController>[];

    for (var i = 0; i < 3; i++) {
      final sizeController = AnimationController(
        duration: const Duration(milliseconds: 750),
        vsync: context,
      );
      final delayedAnimation =
      Tween(begin: 0.3, end: 1.0).animate(sizeController);
      delayedAnimation.addListener(() {
        scaleDoubles[i] = delayedAnimation.value;
        postInvalidate();
      });
      // size.
      controllers.add(sizeController);
    }
    return controllers;
  }

  @override
  void startAnim(AnimationController controller) {
    try {
      controller.repeat(reverse: true);
    } catch (e) {
//
    }
  }

  @override
  Future<void> startAnims(List<AnimationController> controllers) async {
    for (var i = 0; i < controllers.length; i++) {
      await Future.delayed(const Duration(milliseconds: 120), () {
        try {
          startAnim(controllers[i]);
        } catch (e) {
//
        }
      });
    }
  }
}


abstract class Indicator {
  late LoadingState context;
  List<AnimationController>? animationControllers;

  void paint(Canvas canvas, Paint? paint, Size size);

  List<AnimationController> animation();

  void postInvalidate() {
    // ignore: invalid_use_of_protected_member
    context.setState(() {});
  }

  void start() {
    animationControllers = animation();
    if (animationControllers != null) {
      startAnims(animationControllers!);
    }
  }

  void dispose() {
    if (animationControllers != null) {
      for (var i = 0; i < animationControllers!.length; i++) {
        animationControllers![i].dispose();
      }
    }
  }

  void startAnims(List<AnimationController> controllers) {
    for (var i = 0; i < controllers.length; i++) {
      startAnim(controllers[i]);
    }
  }

  void startAnim(AnimationController controller) {
    controller.repeat();
  }
}


class BallScaleIndicator extends Indicator {
  int mAlpha = 0;
  double mScale = 0;

  @override
  void paint(Canvas canvas, Paint? paint, Size size) {
    const circleSpacing = 4;
    final width = size.width;
    final height = size.height;
    paint!.color = paint.color.withAlpha(mAlpha);
    canvas.drawCircle(
      Offset(width / 2, height / 2),
      (width / 2 - circleSpacing) * mScale,
      paint,
    );
  }

  @override
  List<AnimationController> animation() {
    final controllers = <AnimationController>[];
    final alphaController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: context,
    );
    final alpha = IntTween(begin: 255, end: 0).animate(alphaController);
    alpha.addListener(() {
      mAlpha = alpha.value;
      postInvalidate();
    });
    // alpha.
    controllers.add(alphaController);

    final sizeController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: context,
    );
    sizeController.addListener(() {
      mScale = sizeController.value;
    });
    // alpha.
    controllers.add(sizeController);

    return controllers;
  }
}
