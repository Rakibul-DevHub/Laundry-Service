import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/utils/app_logger.dart';
import '../../../../shared/enums/role.dart';
import '../../providers/auth_providers.dart';
import '../../state/sign_up_state.dart';

class SignUpDropdownField extends ConsumerWidget {
  final Role role;
  final String labelText;
  final String? Function(SignUpState) getValue;
  final void Function(WidgetRef, String) onChanged;
  final List<String> items;

  const SignUpDropdownField({
    super.key,
    required this.role,
    required this.labelText,
    required this.getValue,
    required this.onChanged,
    required this.items,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    AppLogger().d("SIGN UP _SignUpDropdownField $labelText SCREEN BUILD");

    final String? value = ref.watch(signUpProvider(role).select(getValue));

    return DropdownButtonFormField<String>(
      initialValue: value,
      items: items
          .map(
            (String item) =>
                DropdownMenuItem<String>(value: item, child: Text(item)),
          )
          .toList(),
      onChanged: (String? v) => onChanged(ref, v ?? items.first),
      decoration: InputDecoration(
        labelText: labelText,
        border: const OutlineInputBorder(),
      ),
    );
  }
}
