import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/storage/secure_storage_service.dart';
import '../api/api_client.dart';

/// [connectivityProvider]
 
/// [authInterceptorProvider]
/// [loggingInterceptorProvider]

/// [dioProvider]
/// [apiClientProvider]


//* ------------------------------------ Connectivity Providers ------------------------------------
// final Provider<Connectivity> connectivityProvider = Provider<Connectivity>(
//   (
//     Ref ref,
//   ) => Connectivity(),
// );


//* ------------------------------------ Secure Storage Providers ------------------------------------
final Provider<SecureStorageService> secureStorageProvider =
    Provider<SecureStorageService>((Ref ref) => SecureStorageService());



//* ------------------------------------ Interceptors Providers ------------------------------------
final Provider<AuthInterceptor> authInterceptorProvider =
    Provider<AuthInterceptor>(
      (Ref ref) => AuthInterceptor(secureStorage: SecureStorageService()),
    );

final Provider<LoggingInterceptor> loggingInterceptorProvider =
    Provider<LoggingInterceptor>((Ref ref) => LoggingInterceptor());


//* ------------------------------------ Network Providers ------------------------------------
final Provider<Dio> dioProvider = Provider<Dio>((Ref ref) {
  return Dio();
});

//* ------------------------------------ Api Client Providers ------------------------------------
final Provider<ApiClient> apiClientProvider = Provider<ApiClient>((Ref ref) {
  final Dio dio = ref.watch(dioProvider);
  final AuthInterceptor authInterceptor = ref.watch(authInterceptorProvider);
  final LoggingInterceptor loggingInterceptor = ref.watch(
    loggingInterceptorProvider,
  );
  return ApiClient(
    dio: dio,
    authInterceptor: authInterceptor,
    loggingInterceptor: loggingInterceptor,
  );
});