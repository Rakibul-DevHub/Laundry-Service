import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/service_request_model.dart';
import '../state/service_requests_state.dart';

class ServiceRequestsNotifier
    extends AutoDisposeNotifier<ServiceRequestsState> {
  @override
  ServiceRequestsState build() {
    Future<dynamic>.microtask(() => _fetchServiceRequests());
    return const ServiceRequestsState(isLoading: true);
  }

  Future<void> _fetchServiceRequests() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      // Simulate API call
      await Future<dynamic>.delayed(const Duration(seconds: 1));

      // Generate dummy data
      final List<ServiceRequestModel>
      dummyRequests = List<ServiceRequestModel>.generate(15, (int index) {
        return ServiceRequestModel(
          id: 'service_rq_$index',
          amount: 50.0,
          date: DateTime.now(),
          customerProfile:
              'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?fm=jpg&q=60&w=3000&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8NHx8dXNlcnN8ZW58MHx8MHx8fDA%3D',
          customerName: 'Md. Nurunnabi',
          customerPhone: '+08801568569089',
          pickupLocation: 'Gulshan 01',
          dropOffLocation: 'Mirpur 12',
          items: const <Item>[
            Item(item: "Shirt", value: "4"),
            Item(item: "Pant", value: "5"),
          ],
          totalItems: 9,
          serviceType: 'Laundry Service',
        );
      });

      state = state.copyWith(
        requests: <ServiceRequestModel>[...state.requests, ...dummyRequests],
        isLoading: false,
        page: state.page + 1,
        hasMore: state.page < 3,
      );
    } catch (e) {
      state = state.copyWith(
        error: 'Failed to load service requests',
        isLoading: false,
      );
    }
  }

  Future<void> refresh() async {
    await _fetchServiceRequests();
  }

  Future<void> loadMore() async {
    if (state.hasMore && !state.isLoading) {
      await _fetchServiceRequests();
    }
  }
}
