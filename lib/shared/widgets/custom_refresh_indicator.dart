import 'package:flutter/material.dart';

import '../../core/config/colors.dart';

class CustomRefreshIndicator extends StatefulWidget {
  final Widget child;
  final RefreshCallback onRefresh;
  final Color? backgroundColor;
  final Color? refreshColor;

  const CustomRefreshIndicator({
    super.key,
    required this.child,
    required this.onRefresh,
    this.backgroundColor,
    this.refreshColor,
  });

  @override
  State<CustomRefreshIndicator> createState() => _CustomRefreshIndicatorState();
}

class _CustomRefreshIndicatorState extends State<CustomRefreshIndicator>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;
  bool _isRefreshing = false;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.2).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    _opacityAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollNotification>(
      onNotification: (ScrollNotification scrollNotification) {
        if (scrollNotification is ScrollStartNotification &&
            scrollNotification.metrics.pixels == 0) {
          _controller.reset();
        }
        return false;
      },
      child: RefreshIndicator(
        color: widget.refreshColor ?? AppColors.paste100,
        backgroundColor: widget.backgroundColor ?? AppColors.white,
        displacement: 40,
        onRefresh: () async {
          setState(() {
            _isRefreshing = true;
          });

          await widget.onRefresh();

          setState(() {
            _isRefreshing = false;
          });
        },
        child: Stack(
          children: <Widget>[
            widget.child,
            if (_isRefreshing)
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: <Color>[
                        AppColors.primary.withValues(alpha: .05),
                        Colors.transparent,
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                ),
              ),
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Center(
                  child: AnimatedBuilder(
                    animation: _controller,
                    builder: (BuildContext context, Widget? child) {
                      return Transform.scale(
                        scale: _scaleAnimation.value,
                        child: Opacity(
                          opacity: _opacityAnimation.value,
                          child: Icon(
                            Icons.refresh,
                            color: widget.refreshColor ?? AppColors.paste100,
                            size: 24,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
