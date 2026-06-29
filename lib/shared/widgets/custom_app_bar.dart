import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';

import '../../../core/extensions/context_extensions.dart';
import '../../core/config/colors.dart';
import '../../core/config/sizes.dart';

enum TitleAlignment { left, center, right }

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final TitleAlignment titleAlignment;
  final Color titleColor;
  final List<Widget>? actions;
  final Widget? leading;
  final Color backgroundColor;
  final double elevation;
  final double alignmentValue;
  final bool showBackBtn;
  final bool showDrawerIcon;
  final GlobalKey<ScaffoldState>? scaffoldKey;
  final VoidCallback onTitlePressCallback;
  static void emptyCallback() {}

  const CustomAppBar({
    super.key,
    this.title,
    this.onTitlePressCallback = emptyCallback,
    this.titleColor = Colors.black,
    this.titleAlignment = TitleAlignment.center,
    this.showBackBtn = true,
    this.showDrawerIcon = false,
    this.alignmentValue = -30.0,
    this.actions,
    this.leading,
    this.scaffoldKey,
    this.backgroundColor = AppColors.white,
    this.elevation = 0.0,
  }) : assert(
         !(showBackBtn && showDrawerIcon),
         'Cannot show both back button and drawer icon',
       ),
       assert(
         !showDrawerIcon || scaffoldKey != null,
         'scaffoldKey must be provided if showDrawerIcon is true',
       );

  @override
  Widget build(BuildContext context) {
    Widget? leading;

    if (showBackBtn) {
      leading = IconButton(
        icon: const Icon(
          Icons.arrow_back,
          size: 24.0,
        ),
        onPressed: () => context.pop(),
      );
    } else if (showDrawerIcon) {
      leading = IconButton(
        icon: SvgPicture.asset(
          "AppIcons.sideDrawerIcon",
          width: 24.0,
          height: 24.0,
        ),
        onPressed: () {
          if (scaffoldKey != null &&
              scaffoldKey!.currentState != null &&
              scaffoldKey!.currentState!.hasDrawer) {
            if (!scaffoldKey!.currentState!.isDrawerOpen) {
              scaffoldKey!.currentState!.openDrawer();
            } else {
              scaffoldKey!.currentState!.closeDrawer();
            }
          }
        },
      );
    } else if (this.leading != null) {
      leading = Padding(
        padding: const EdgeInsets.all(AppSizes.sm),
        child: this.leading,
      );
    }

    return Container(
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.grey100, width: .2)),
      ),
      child: AppBar(
        shadowColor: AppColors.paste100,
        surfaceTintColor: AppColors.paste100,
        backgroundColor: backgroundColor,
        elevation: elevation,
        scrolledUnderElevation: .6,
        leading: leading,
        automaticallyImplyLeading: false,
        title: title != null
            ? GestureDetector(
                onTap: onTitlePressCallback,
                child: Align(
                  alignment: _getTitleAlignment(),
                  child: Transform.translate(
                    offset: titleAlignment == TitleAlignment.center
                        ? Offset(alignmentValue, 0)
                        : Offset.zero,
                    child: Text(
                      title!,
                      style: context.txtTheme.bodyLarge?.copyWith(
                        color: titleColor,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ),
              )
            : null,
        centerTitle: false,
        actions: actions,
      ),
    );
  }

  Alignment _getTitleAlignment() {
    switch (titleAlignment) {
      case TitleAlignment.left:
        return Alignment.centerLeft;
      case TitleAlignment.right:
        return Alignment.centerRight;
      case TitleAlignment.center:
        return Alignment.center;
    }
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
