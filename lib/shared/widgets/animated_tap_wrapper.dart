import 'package:book_app/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class AnimatedTapWrapper extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;
  final BorderRadius? borderRadius;
  final Duration duration;
  final double pressedScale;
  final bool enabled;
  final bool enableShadow;

  const AnimatedTapWrapper({
    super.key,
    required this.child,
    this.onTap,
    this.borderRadius,
    this.duration = const Duration(milliseconds: 170),
    this.pressedScale = 0.97,
    this.enabled = true,
    this.enableShadow = true,
  });

  @override
  State<AnimatedTapWrapper> createState() => _AnimatedTapWrapperState();
}

class _AnimatedTapWrapperState extends State<AnimatedTapWrapper> {
  bool _isPressed = false;

  bool get _canInteract => widget.enabled && widget.onTap != null;

  void _setPressed(bool value) {
    if (!_canInteract || _isPressed == value) return;
    setState(() => _isPressed = value);
  }

  @override
  Widget build(BuildContext context) {
    final borderRadius = widget.borderRadius ?? BorderRadius.circular(14);

    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTapDown: (_) => _setPressed(true),
      onTapUp: (_) => _setPressed(false),
      onTapCancel: () => _setPressed(false),
      onTap: widget.onTap,
      child: AnimatedScale(
        scale: _isPressed ? widget.pressedScale : 1,
        duration: widget.duration,
        curve: Curves.easeOut,
        child: AnimatedContainer(
          duration: widget.duration,
          curve: Curves.easeOut,
          decoration: BoxDecoration(
            borderRadius: borderRadius,
            boxShadow: widget.enableShadow
                ? [
                    BoxShadow(
                      color: (_isPressed
                              ? AppColors.premiumYellow
                              : AppColors.white)
                          .withOpacity(_isPressed ? 0.22 : 0.08),
                      blurRadius: _isPressed ? 14 : 8,
                      spreadRadius: _isPressed ? 0.4 : 0,
                      offset: Offset(0, _isPressed ? 5 : 2),
                    ),
                  ]
                : const [],
          ),
          child: widget.child,
        ),
      ),
    );
  }
}

extension AnimatedTapExtension on Widget {
  Widget withAnimatedTap({
    VoidCallback? onTap,
    BorderRadius? borderRadius,
    Duration duration = const Duration(milliseconds: 170),
    double pressedScale = 0.97,
    bool enabled = true,
    bool enableShadow = true,
  }) {
    return AnimatedTapWrapper(
      onTap: onTap,
      borderRadius: borderRadius,
      duration: duration,
      pressedScale: pressedScale,
      enabled: enabled,
      enableShadow: enableShadow,
      child: this,
    );
  }
}
