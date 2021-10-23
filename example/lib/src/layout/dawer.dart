import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

enum HorizontalDirection {
  start,
  end,
}

class CustomDawer extends StatefulWidget {
  final Widget child;
  final bool isVisible;
  final HorizontalDirection direction;
  const CustomDawer({
    Key? key,
    required this.child,
    required this.isVisible,
    required this.direction,
  }) : super(key: key);

  @override
  _CustomCustomDawerState createState() => _CustomCustomDawerState();
}

class _CustomCustomDawerState extends State<CustomDawer>
    with SingleTickerProviderStateMixin<CustomDawer> {
  late AnimationController _animation;

  Animation<Offset> get _slideInAnimation => Tween<Offset>(
        begin: Offset(
          widget.direction == HorizontalDirection.start ? -1.0 : 1.0,
          0.0,
        ),
        end: const Offset(0.0, 0.0),
      ).animate(
        CurvedAnimation(
          parent: _animation,
          curve: Curves.linearToEaseOut,
        ),
      );

  @override
  void initState() {
    _animation = AnimationController(
      vsync: this,
      duration: const Duration(
        milliseconds: 500,
      ),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isVisible) {
      _animation.forward();
    } else if (!widget.isVisible) {
      _animation.reverse();
    }
    return SlideTransition(
      position: _slideInAnimation,
      child: Container(
        width: 300,
        decoration: BoxDecoration(
          borderRadius: widget.direction == HorizontalDirection.start
              ? _roundCornersOnTheRight()
              : _roundCornersOnTheLeft(),
          gradient: RadialGradient(
            center: widget.direction == HorizontalDirection.start
                ? Alignment.centerLeft
                : Alignment.centerRight,
            colors: [
              Theme.of(context).primaryColor,
              Theme.of(context).primaryColorDark
            ],
          ),
        ),
        child: widget.child,
      ),
    );
  }

  BorderRadius _roundCornersOnTheRight() {
    return const BorderRadius.only(
      topRight: Radius.circular(12.0),
      bottomRight: Radius.circular(12.0),
    );
  }

  BorderRadius _roundCornersOnTheLeft() {
    return const BorderRadius.only(
      topLeft: Radius.circular(12.0),
      bottomLeft: Radius.circular(12.0),
    );
  }
}
