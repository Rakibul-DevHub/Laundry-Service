import 'package:drop_n_fresh/app/providers/app_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants/storage_keys.dart';
import '../../core/storage/secure_storage_service.dart';
import '../enums/role.dart';

final AsyncNotifierProvider<SelectedRoleNotifier, Role> selectedRoleProvider =
    AsyncNotifierProvider<SelectedRoleNotifier, Role>(
      () => SelectedRoleNotifier(),
    );

class SelectedRoleNotifier extends AsyncNotifier<Role> {
  @override
  Future<Role> build() async {
    final SecureStorageService storage = ref.read(secureStorageProvider);
    final String? storedRoleName = await storage.read(StorageKeys.role);

    Role role;
    try {
      if (storedRoleName != null &&
          Role.values.map((Role r) => r.name).contains(storedRoleName)) {
        role = Role.values.byName(storedRoleName);
      } else {
        role = Role.user;
      }
    } catch (e) {
      role = Role.user;
    }

    return role;
  }

  Future<void> setRole(Role role) async {
    final SecureStorageService storage = ref.read(secureStorageProvider);
    await storage.write(StorageKeys.role, role.name);
    state = AsyncData<Role>(role);
  }
}
