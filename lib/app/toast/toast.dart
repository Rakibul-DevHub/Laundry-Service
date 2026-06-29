import 'package:flutter/material.dart';

enum ToastType { error, success, warning, info, noInternet }

enum ToastPosition { top, bottom }

class Toast {
  static OverlayEntry? _overlayEntry;
  static bool _isShowing = false;
  static BuildContext? _cachedContext;

  /// Auto-capture context from any widget build
  static set captureContext(BuildContext context) {
    _cachedContext = context;
  }

  /// Get context automatically - simplified approach
  static BuildContext? get _context {
    if (_cachedContext != null && _cachedContext!.mounted) {
      return _cachedContext;
    }
    return null;
  }

  /// Show toast without any setup!
  static void show({
    required String message,
    IconData icon = Icons.info,
    ToastPosition position = ToastPosition.top,
    Duration duration = const Duration(seconds: 3),
    Color backgroundColor = const Color(0xFF2D2D2D),
    Color textColor = Colors.white,
    Color iconColor = Colors.white,
    ToastType type = ToastType.info,
    BuildContext? context,
  }) {
    final BuildContext? ctx = context ?? _context;

    if (ctx == null) {
      debugPrint(
        'Toast: No context available. Wrap your app with ToastProvider or pass context manually.',
      );
      return;
    }

    if (_isShowing) {
      hide();
    }

    // Set icon and color based on type
    if (type == ToastType.error) {
      icon = Icons.error_outline;
      iconColor = Colors.red;
    } else if (type == ToastType.success) {
      icon = Icons.check_circle_outline;
      iconColor = Colors.green;
    } else if (type == ToastType.warning) {
      icon = Icons.warning_outlined;
      iconColor = Colors.orange;
    } else if (type == ToastType.info) {
      icon = Icons.info_outline;
      iconColor = Colors.white;
    } else if (type == ToastType.noInternet) {
      icon = Icons.error_outline;
      iconColor = Colors.white;
    }

    _overlayEntry = OverlayEntry(
      builder: (BuildContext context) => _ToastWidget(
        message: message,
        icon: icon,
        backgroundColor: backgroundColor,
        textColor: textColor,
        iconColor: iconColor,
        position: position,
      ),
    );

    Overlay.of(ctx).insert(_overlayEntry!);
    _isShowing = true;

    Future<dynamic>.delayed(duration, () {
      hide();
    });
  }

  /// Quick methods - no context needed (if properly set up)
  static void showError(
    String message, {
    Duration? duration,
    BuildContext? context,
    ToastPosition position = ToastPosition.top,
  }) {
    show(
      message: message,
      type: ToastType.error,
      duration: duration ?? const Duration(seconds: 3),
      context: context,
    );
  }

  static void showSuccess(
    String message, {
    Duration? duration,
    BuildContext? context,
    ToastPosition position = ToastPosition.top,
  }) {
    show(
      message: message,
      type: ToastType.success,
      duration: duration ?? const Duration(seconds: 3),
      context: context,
    );
  }

  static void showWarning(
    String message, {
    Duration? duration,
    BuildContext? context,
    ToastPosition position = ToastPosition.top,
  }) {
    show(
      message: message,
      type: ToastType.warning,
      duration: duration ?? const Duration(seconds: 3),
      context: context,
    );
  }

  static void showInfo(
    String message, {
    Duration? duration,
    BuildContext? context,
    ToastPosition position = ToastPosition.top,
  }) {
    show(
      message: message,
      type: ToastType.info,
      duration: duration ?? const Duration(seconds: 3),
      context: context,
    );
  }

  static void showNoInternet({
    Duration? duration,
    BuildContext? context,
    ToastPosition position = ToastPosition.top,
  }) {
    show(
      message: 'No internet connection',
      type: ToastType.noInternet,
      duration: duration ?? const Duration(seconds: 3),
      context: context,
      position: position,
    );
  }

  static void hide() {
    if (_isShowing && _overlayEntry != null) {
      // Try to animate out if state is available
      if (_currentToastState != null && _currentToastState!.mounted) {
        _currentToastState!.hideWithAnimation(() {
          if (_overlayEntry != null) {
            _overlayEntry!.remove();
            _overlayEntry = null;
            _isShowing = false;
          }
        });
      } else {
        // Fallback: remove immediately
        _overlayEntry!.remove();
        _overlayEntry = null;
        _isShowing = false;
      }
    }
  }
}

/// Context provider widget - wrap your MaterialApp with this
class ToastProvider extends StatelessWidget {
  const ToastProvider({super.key, required this.child});
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return Overlay(
      initialEntries: <OverlayEntry>[
        OverlayEntry(
          builder: (BuildContext ctx) {
            Toast.captureContext = ctx;
            return child ?? const SizedBox.shrink();
          },
        ),
      ],
    );
  }
}

class _ToastWidget extends StatefulWidget {
  const _ToastWidget({
    required this.message,
    required this.icon,
    required this.backgroundColor,
    required this.textColor,
    required this.iconColor,
    required this.position,
  });

  final String message;
  final IconData icon;
  final Color backgroundColor;
  final Color textColor;
  final Color iconColor;
  final ToastPosition position;

  @override
  State<_ToastWidget> createState() => _ToastWidgetState();
}

// Global reference to current toast state for hide animation
_ToastWidgetState? _currentToastState;

class _ToastWidgetState extends State<_ToastWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    // Set as current toast state for hide animation
    _currentToastState = this;

    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _controller.forward();
  }

  @override
  void dispose() {
    // Clear reference when disposing
    if (_currentToastState == this) {
      _currentToastState = null;
    }
    _controller.dispose();
    super.dispose();
  }

  /// Hide with smooth animation
  void hideWithAnimation(VoidCallback onComplete) {
    if (mounted) {
      _controller.reverse().then((_) {
        if (mounted) {
          onComplete();
        }
      });
    } else {
      onComplete();
    }
  }

  @override
  Widget build(BuildContext context) {
    // Auto-capture context whenever toast is built
    Toast.captureContext = context;

    return Positioned(
      bottom: widget.position == ToastPosition.top
          ? null
          : MediaQuery.of(context).padding.bottom + 20,
      top: widget.position == ToastPosition.bottom
          ? null
          : MediaQuery.of(context).padding.top + 10,
      left: 20,
      right: 20,
      child: SlideTransition(
        position: _slideAnimation,
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: GestureDetector(
            onVerticalDragUpdate: (DragUpdateDetails details) {
              if (details.primaryDelta != null && details.primaryDelta! > 10) {
                _controller.reverse().then((_) => Toast.hide());
              }
            },
            child: Dismissible(
              key: const ValueKey<String>("toast"),
              direction: DismissDirection.horizontal,
              onDismissed: (_) {
                Toast.hide();
              },
              child: Material(
                color: Colors.transparent,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: widget.backgroundColor,
                    borderRadius: BorderRadius.circular(8.0),
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.2),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Icon(widget.icon, color: widget.iconColor, size: 24.0),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          widget.message,
                          style: TextStyle(
                            color: widget.textColor,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
