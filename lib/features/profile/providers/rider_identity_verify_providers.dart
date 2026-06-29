import 'package:drop_n_fresh/features/profile/notifier/rider_documents_submit_notifier.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../shared/models/rider_documents_model.dart';
import '../notifier/rider_identity_verify_home_notifier.dart';
import '../notifier/rider_identity_verify_notifier.dart';
import '../notifier/vehicle_info_notifier.dart';
import '../state/rider_documents_submit_state.dart';
import '../state/rider_verification_state.dart';
import '../state/vehicle_info_state.dart';

final NotifierProvider<RiderVerificationNotifier, RiderVerificationState>
riderIdentityVerifyProvider =
    NotifierProvider<RiderVerificationNotifier, RiderVerificationState>(
      RiderVerificationNotifier.new,
    );

final NotifierProvider<
  RiderIdentityVerifyHomeNotifier,
  AsyncValue<RiderDocumentsModel?>
>
riderIdentityVerifyHomeProvider =
    NotifierProvider<
      RiderIdentityVerifyHomeNotifier,
      AsyncValue<RiderDocumentsModel?>
    >(
      RiderIdentityVerifyHomeNotifier.new,
    );

final AutoDisposeNotifierProvider<VehicleInfoNotifier, VehicleInfoState>
vehicleInfoProvider =
    AutoDisposeNotifierProvider<VehicleInfoNotifier, VehicleInfoState>(
      VehicleInfoNotifier.new,
    );
final AutoDisposeNotifierProvider<
  RiderDocumentsSubmitNotifier,
  RiderDocumentsSubmitState
>
riderDocumentsSubmitProvider =
    AutoDisposeNotifierProvider<
      RiderDocumentsSubmitNotifier,
      RiderDocumentsSubmitState
    >(
      RiderDocumentsSubmitNotifier.new,
    );
