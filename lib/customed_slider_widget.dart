import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Thêm quyền có thể rung thiết bị
//  <uses-permission android:name="android.permission.VIBRATE"/>

class CustomedSliderWidget extends StatefulWidget {
  const CustomedSliderWidget(
      {Key? key,
      required this.buttonTitle,
      this.height = 40,
      this.buttonWidth = 140,
      this.backgroundDecoration,
      this.buttonDecoration,
      this.duration = const Duration(milliseconds: 1000),
      this.deltaX = 20,
      this.curve = Curves.bounceOut,
      this.onComplete,
      this.disable = false,
      this.status = false,
      this.reverse = false,
      this.prefix,
      this.suffix,
      this.backgroundPadding})
      : super(key: key);

  final Widget buttonTitle;
  final double height;
  final BoxDecoration? backgroundDecoration;
  final BoxDecoration? buttonDecoration;
  final double buttonWidth;
  final Duration duration;
  final double deltaX;
  final Curve curve;
  final Function(bool value)? onComplete;
  final bool disable;
  final bool status;
  final bool reverse;
  final EdgeInsetsGeometry? backgroundPadding;
  final Widget? prefix;
  final Widget? suffix;

  @override
  State<CustomedSliderWidget> createState() => _CustomedSliderWidgetState();
}

class _CustomedSliderWidgetState extends State<CustomedSliderWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  bool isDisposed = true;
  double _leftPosition = 0;
  final _duration = const Duration(milliseconds: 5);

  late Widget buttonTitle;
  late double height;
  late double buttonWidth;
  late double maxWidth;
  BoxDecoration? backgroundDecoration;
  BoxDecoration? buttonDecoration;
  late bool disable;
  late bool status;
  Function(bool value)? onComplete;
  late bool reverse;
  EdgeInsetsGeometry? backgroundPadding;
  Widget? prefix;
  Widget? suffix;

  @override
  void initState() {
    buttonTitle = widget.buttonTitle;
    height = widget.height;
    backgroundDecoration = widget.backgroundDecoration;
    buttonDecoration = widget.buttonDecoration;
    buttonWidth = widget.buttonWidth;
    disable = widget.disable;
    onComplete = widget.onComplete;
    status = widget.status;
    reverse = widget.reverse;
    backgroundPadding = widget.backgroundPadding;
    prefix = widget.prefix;
    suffix = widget.suffix;

    controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    )..addListener(() {
        if (controller.isCompleted) {
          Future.delayed(const Duration(seconds: 1)).then(
            (value) =>
                !status && !isDisposed ? controller.forward(from: 0) : null,
          );
        }
      });

    isDisposed = false;

    if (!status) {
      controller.forward();
    }

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if ((status && !reverse) || (!status && reverse)) {
        _leftPosition = maxWidth;
        if (mounted) setState(() {});
      }
    });

    super.initState();
  }

  @override
  void didUpdateWidget(covariant CustomedSliderWidget oldWidget) {
    buttonTitle = widget.buttonTitle;
    height = widget.height;
    backgroundDecoration = widget.backgroundDecoration;
    buttonDecoration = widget.buttonDecoration;
    buttonWidth = widget.buttonWidth;
    disable = widget.disable;
    onComplete = widget.onComplete;
    status = widget.status;
    reverse = widget.reverse;
    backgroundPadding = widget.backgroundPadding;
    prefix = widget.prefix;
    suffix = widget.suffix;

    if (status) {
      _leftPosition = reverse ? 0 : maxWidth;
    }

    if (widget.reverse != oldWidget.reverse) {
      _leftPosition = maxWidth - _leftPosition;
    }

    if (mounted) setState(() {});

    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    isDisposed = true;
    controller.dispose();
    super.dispose();
  }

  double shake(double value) =>
      2 * (0.5 - (0.5 - widget.curve.transform(value)).abs());

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: double.infinity,
      child: LayoutBuilder(builder: (context, boxConstraints) {
        maxWidth = boxConstraints.maxWidth - buttonWidth;
        return Stack(
          children: [
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              bottom: 0,
              child: AnimatedContainer(
                duration: Duration(milliseconds: 500),
                margin: backgroundPadding,
                height: height,
                decoration: backgroundDecoration,
                width: double.infinity,
                child: Row(
                  children: [
                    prefix ?? const SizedBox.shrink(),
                    const Spacer(),
                    suffix ?? const SizedBox.shrink(),
                  ],
                ),
              ),
            ),
            Positioned(
              top: 0,
              left: _leftPosition,
              bottom: 0,
              child: GestureDetector(
                onPanEnd: (details) => !disable
                    ? onPanEnd(
                        thresholdPosition:
                            (boxConstraints.maxWidth - buttonWidth) *
                                (reverse ? 1 : 2) /
                                3,
                      )
                    : null,
                onPanUpdate: (details) {
                  if (!disable) {
                    _leftPosition += details.delta.dx;
                    if (_leftPosition <= 0) _leftPosition = 0;
                    if (_leftPosition >=
                        boxConstraints.maxWidth - buttonWidth) {
                      _leftPosition = boxConstraints.maxWidth - buttonWidth;
                    }
                    setState(() {});
                  }
                },
                child: AnimatedBuilder(
                  animation: controller,
                  builder: (context, child) {
                    return Transform.translate(
                      offset: Offset(
                          widget.deltaX *
                              shake(controller.value) *
                              (reverse ? -1 : 1),
                          0),
                      child: child,
                    );
                  },
                  child: Container(
                    height: height,
                    decoration: buttonDecoration,
                    width: buttonWidth,
                    child: Center(
                      child: buttonTitle,
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      }),
    );
  }

  void onPanEnd({
    required double thresholdPosition,
  }) {
    Timer.periodic(_duration, (timer) {
      if (_leftPosition > thresholdPosition) {
        _leftPosition += 2;
      } else {
        _leftPosition -= 2;
      }

      if (_leftPosition <= 0) {
        _leftPosition = 0;
        if (onComplete != null) {
          onComplete!(reverse);
        }
        status = reverse;
        _checkStatusAndRunAnimation();
        timer.cancel();
      } else if (_leftPosition >= maxWidth) {
        _leftPosition = maxWidth;
        HapticFeedback.mediumImpact();
        if (onComplete != null) {
          onComplete!(!reverse);
        }
        status = !reverse;
        _checkStatusAndRunAnimation();
        timer.cancel();
      }
      setState(() {});
    });
  }

  void _checkStatusAndRunAnimation() {
    if (status) {
      controller.reset();
    } else {
      controller.forward(from: 0);
    }
  }
}
