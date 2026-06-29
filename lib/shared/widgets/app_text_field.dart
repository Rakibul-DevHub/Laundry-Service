import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/extensions/context_extensions.dart';

class AppTextField extends StatefulWidget {
  final TextEditingController? controller;
  final String labelText;
  final String? initialValue;
  final String? errorText;
  final TextInputType keyboardType;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final bool obscureText;
  final int minLines;
  final int maxLines;
  final bool readOnly;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onTap;
  final VoidCallback? onUnfocus;
  final VoidCallback onEditingComplete;
  final Color? textColor;
  final Color? labelColor;
  final Color? cursorColor;
  final List<TextInputFormatter>? textInputFormatters;

  const AppTextField({
    super.key,
    this.controller,
    required this.labelText,
    this.errorText,
    this.initialValue,
    this.keyboardType = TextInputType.text,
    this.prefixIcon,
    this.obscureText = false,
    this.onChanged,
    this.suffixIcon,
    this.minLines = 1,
    this.maxLines = 1,
    this.readOnly = false,
    this.onTap,
    this.onUnfocus,
    this.onEditingComplete = emptyFunction,
    this.textColor,
    this.labelColor,
    this.cursorColor,
    this.textInputFormatters,
  });

  static void emptyFunction() {}

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _focusNode.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    _focusNode.removeListener(_onFocusChange);
    _focusNode.dispose();
    super.dispose();
  }

  void _onFocusChange() {
    if (!_focusNode.hasFocus) {
      widget.onUnfocus?.call();
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      focusNode: _focusNode,
      onTap: widget.onTap,
      onTapOutside: (PointerDownEvent event) {
        context.hideKeyboard;
      },
      inputFormatters: widget.textInputFormatters,
      initialValue: widget.initialValue,
      onEditingComplete: widget.onEditingComplete,
      controller: widget.controller,
      obscureText: widget.obscureText,
      keyboardType: widget.keyboardType,
      onChanged: widget.onChanged,
      readOnly: widget.readOnly,
      minLines: widget.minLines,
      maxLines: widget.maxLines,
      cursorColor: widget.cursorColor,
      style: context.txtTheme.bodyMedium?.copyWith(
        color: widget.textColor,
      ),
      textAlign: TextAlign.start,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(
          vertical: 8.0,
          horizontal: 8.0,
        ),
        alignLabelWithHint: true,
        labelStyle: TextStyle(color: widget.labelColor),
        prefixIcon: widget.prefixIcon != null
            ? Padding(
                padding: const EdgeInsets.all(8.0),
                child: widget.prefixIcon!,
              )
            : null,
        suffixIcon: widget.suffixIcon,
        labelText: widget.labelText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        errorText: widget.errorText,
      ),
    );
  }
}
