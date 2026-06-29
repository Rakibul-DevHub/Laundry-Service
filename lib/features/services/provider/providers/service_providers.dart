import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/service_list_response.dart';
import '../notifier/create_service_notifier.dart';
import '../notifier/service_detail_notifier.dart';
import '../notifier/services_list_notifier.dart';
import '../state/create_service_form_state.dart';

// final AutoDisposeNotifierProvider<ServicesNotifier, ServicesState>
// servicesProvider = AutoDisposeNotifierProvider<ServicesNotifier, ServicesState>(
//   ServicesNotifier.new,
// );

final AutoDisposeNotifierProvider<CreateServiceNotifier, CreateServiceFormState>
createServiceProvider =
    NotifierProvider.autoDispose<CreateServiceNotifier, CreateServiceFormState>(
      CreateServiceNotifier.new,
    );

final AutoDisposeNotifierProvider<
  ServicesListNotifier,
  AsyncValue<List<ProviderService>>
>
servicesListProvider =
    NotifierProvider.autoDispose<
      ServicesListNotifier,
      AsyncValue<List<ProviderService>>
    >(
      ServicesListNotifier.new,
    );

final AutoDisposeAsyncNotifierProviderFamily<ServiceDetailNotifier, ProviderService, String> serviceDetailProvider = AsyncNotifierProvider.autoDispose.family<ServiceDetailNotifier, ProviderService, String>(
  ServiceDetailNotifier.new,
);
