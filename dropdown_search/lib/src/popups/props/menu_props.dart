import 'package:dropdown_search/src/base_dropdown_search.dart';
import 'package:flutter/material.dart';

enum MenuAlign {
  bottomStart,
  bottomCenter,
  bottomEnd,
  topStart,
  topCenter,
  topEnd,
}

extension MenuAlignDirection on MenuAlign {
  bool get isDown =>
      this == MenuAlign.bottomStart ||
      this == MenuAlign.bottomCenter ||
      this == MenuAlign.bottomEnd;

  bool get isUp => !isDown;

  MenuAlign get reverse {
    switch (this) {
      case MenuAlign.topStart:
        return MenuAlign.bottomStart;
      case MenuAlign.topCenter:
        return MenuAlign.bottomCenter;
      case MenuAlign.topEnd:
        return MenuAlign.bottomEnd;
      case MenuAlign.bottomStart:
        return MenuAlign.topStart;
      case MenuAlign.bottomCenter:
        return MenuAlign.topCenter;
      case MenuAlign.bottomEnd:
        return MenuAlign.topEnd;
    }
  }
}

class MenuProps {
  final MenuAlign? align;
  final ShapeBorder? shape;
  final double? elevation;
  final Color? barrierColor;
  final Color? backgroundColor;
  final bool barrierDismissible;
  final Clip clipBehavior;
  final BorderRadiusGeometry? borderRadius;
  final Color? shadowColor;
  final bool borderOnForeground;
  final String? barrierLabel;
  final PositionCallback? positionCallback;
  final Duration? reverseTransitionDuration;
  final Duration? transitionDuration;
  final Color? color;
  final String? semanticLabel;
  final Color? surfaceTintColor;
  final EdgeInsets? margin;
  final RouteTransitionsBuilder? transitionBuilder;

  const MenuProps({
    this.align,
    this.barrierLabel,
    this.elevation,
    this.shape = const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(4.0))),
    this.positionCallback,
    this.barrierColor,
    this.backgroundColor,
    this.barrierDismissible = true,
    this.clipBehavior = Clip.none,
    this.borderOnForeground = false,
    this.borderRadius,
    this.shadowColor,
    this.color,
    this.transitionDuration,
    this.reverseTransitionDuration,
    this.semanticLabel,
    this.surfaceTintColor,
    this.margin,
    this.transitionBuilder,
  });
}

class CupertinoMenuProps {
  final MenuAlign? align;
  final ShapeBorder? shape;
  final double? elevation;
  final Color? barrierColor;
  final Color? backgroundColor;
  final bool barrierDismissible;
  final Clip clipBehavior;
  final BorderRadiusGeometry? borderRadius;
  final Color? shadowColor;
  final bool borderOnForeground;
  final String? barrierLabel;
  final PositionCallback? positionCallback;
  final Duration? reverseTransitionDuration;
  final Duration? transitionDuration;
  final Color? color;
  final String? semanticLabel;
  final Color? surfaceTintColor;
  final EdgeInsets? margin;
  final RouteTransitionsBuilder? transitionBuilder;

  const CupertinoMenuProps({
    this.align,
    this.barrierLabel,
    this.elevation,
    this.shape = const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(12))),
    this.positionCallback,
    this.barrierColor,
    this.backgroundColor,
    this.barrierDismissible = true,
    this.clipBehavior = Clip.none,
    this.borderOnForeground = false,
    this.borderRadius,
    this.shadowColor,
    this.color,
    this.transitionDuration,
    this.reverseTransitionDuration,
    this.semanticLabel,
    this.surfaceTintColor,
    this.margin = const EdgeInsets.only(top: 8),
    this.transitionBuilder,
  });
}

class AdaptiveMenuProps {
  final CupertinoMenuProps cupertinoProps;
  final MenuProps materialProps;

  const AdaptiveMenuProps({
    this.materialProps = const MenuProps(),
    this.cupertinoProps = const CupertinoMenuProps(),
  });
}
