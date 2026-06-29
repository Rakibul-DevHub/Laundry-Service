// ignore_for_file: always_specify_types

import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:drop_n_fresh/shared/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../app/theme/styles/app_text_styles.dart';
import '../../../core/config/colors.dart';
import '../models/jobs_details_model.dart';

enum _PermissionStatus { checking, granted, denied, permanentlyDenied }

enum _RouteStatus { idle, loading, success, error }

class JobMapScreen extends StatefulWidget {
  final JobsDetailsModel job;
  final bool isPickupLeg;

  const JobMapScreen({
    super.key,
    required this.job,
    this.isPickupLeg = true,
  });

  @override
  State<JobMapScreen> createState() => _JobMapScreenState();
}

class _JobMapScreenState extends State<JobMapScreen> {
  // ─── Map ────────────────────────────────────────────────────────────────────
  GoogleMapController? _mapController;
  bool _mapLoaded = false;
  bool _showTraffic = false;

  late LatLng _pickupLocation;
  late LatLng _dropoffLocation;
  late Set<Marker> _markers;
  late CameraPosition _initialCameraPosition;
  Set<Polyline> _polylines = <Polyline>{};

  // ─── Permission ─────────────────────────────────────────────────────────────
  _PermissionStatus _permissionStatus = _PermissionStatus.checking;

  // ─── Route ──────────────────────────────────────────────────────────────────
  _RouteStatus _routeStatus = _RouteStatus.idle;
  String _distanceText = '';
  String _durationText = '';
  String _routeError = '';

  late final Dio _dio;

  static const String _apiKey = 'AIzaSyAFmA9xSsIiz0YlwK5w_qSL3PYEWwHH0zU';

  // ─── Lifecycle ───────────────────────────────────────────────────────────────

  @override
  void initState() {
    super.initState();
    _initDio();
    _initMapData();
    _checkPermission();
  }

  void _initDio() {
    _dio = Dio(
      BaseOptions(
        baseUrl: 'https://maps.googleapis.com/maps/api/directions/',
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 15),
        responseType: ResponseType.plain,
      ),
    );
  }

  @override
  void dispose() {
    _dio.close(force: true);
    _mapController?.dispose();
    super.dispose();
  }

  // ─── Permission ──────────────────────────────────────────────────────────────

  Future<void> _checkPermission() async {
    final PermissionStatus status = await Permission.locationWhenInUse.status;

    if (status.isGranted) {
      _setPermission(_PermissionStatus.granted);
      return;
    }

    if (status.isPermanentlyDenied) {
      _setPermission(_PermissionStatus.permanentlyDenied);
      return;
    }

    final PermissionStatus result = await Permission.locationWhenInUse
        .request();

    if (result.isGranted) {
      _setPermission(_PermissionStatus.granted);
    } else if (result.isPermanentlyDenied) {
      _setPermission(_PermissionStatus.permanentlyDenied);
    } else {
      _setPermission(_PermissionStatus.denied);
    }
  }

  void _setPermission(_PermissionStatus status) {
    if (mounted) {
      setState(() => _permissionStatus = status);
    }
  }

  // ─── Map data ────────────────────────────────────────────────────────────────

  void _initMapData() {
    final double pickupLat =
        widget.job.pickupLocationDetails?.latitude ?? 23.794798;
    final double pickupLng =
        widget.job.pickupLocationDetails?.longitude ?? 90.4142694;
    final double dropoffLat =
        widget.job.dropoffLocationDetails?.latitude ?? 23.7777571;
    final double dropoffLng =
        widget.job.dropoffLocationDetails?.longitude ?? 90.40574079999999;

    _pickupLocation = LatLng(pickupLat, pickupLng);
    _dropoffLocation = LatLng(dropoffLat, dropoffLng);

    _initialCameraPosition = CameraPosition(
      target: LatLng(
        (_pickupLocation.latitude + _dropoffLocation.latitude) / 2,
        (_pickupLocation.longitude + _dropoffLocation.longitude) / 2,
      ),
      zoom: 13,
    );

    _markers = <Marker>{
      Marker(
        markerId: const MarkerId('pickup'),
        position: _pickupLocation,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
        infoWindow: InfoWindow(
          title: widget.isPickupLeg ? '📍 Pickup' : '🏪 Provider',
          snippet: widget.job.pickupLocation,
        ),
        onTap: () => _showLocationSheet(
          widget.isPickupLeg ? 'Pickup Location' : 'Provider',
          widget.job.pickupLocation,
          _pickupLocation,
        ),
      ),
      Marker(
        markerId: const MarkerId('dropoff'),
        position: _dropoffLocation,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
        infoWindow: InfoWindow(
          title: widget.isPickupLeg ? '🏪 Dropoff' : '📍 Customer',
          snippet: widget.job.dropOffLocation,
        ),
        onTap: () => _showLocationSheet(
          widget.isPickupLeg ? 'Dropoff Location' : 'Customer',
          widget.job.dropOffLocation,
          _dropoffLocation,
        ),
      ),
    };
  }

  // ─── Route fetch ─────────────────────────────────────────────────────────────

  Future<void> _fetchRoute() async {
    if (!mounted) {
      return;
    }
    setState(() {
      _routeStatus = _RouteStatus.loading;
      _routeError = '';
    });

    try {
      final Response<dynamic> response = await _dio.get(
        'json',
        queryParameters: <String, dynamic>{
          'origin': '${_pickupLocation.latitude},${_pickupLocation.longitude}',
          'destination':
              '${_dropoffLocation.latitude},${_dropoffLocation.longitude}',
          'mode': 'driving',
          'key': _apiKey,
        },
      );

      final Map<String, dynamic> data =
          json.decode(response.data as String) as Map<String, dynamic>;
      final String status = data['status'] as String? ?? '';

      if (status != 'OK') {
        throw Exception('Directions API: $status');
      }

      final List<dynamic> routes = data['routes'] as List? ?? <dynamic>[];
      if (routes.isEmpty) {
        throw Exception('No routes found');
      }

      final Map<String, dynamic> firstRoute = routes[0] as Map<String, dynamic>;
      final List<dynamic> legs = firstRoute['legs'] as List? ?? <dynamic>[];
      if (legs.isEmpty) {
        throw Exception('No legs found');
      }

      final Map<String, dynamic> firstLeg = legs[0] as Map<String, dynamic>;
      final String encodedPoints =
          (firstRoute['overview_polyline'] as Map<String, dynamic>?)?['points']
              as String? ??
          '';

      if (encodedPoints.isEmpty) {
        throw Exception('Empty polyline');
      }

      final List<LatLng> points = _decodePolyline(encodedPoints);

      if (!mounted) {
        return;
      }
      setState(() {
        _distanceText =
            (firstLeg['distance'] as Map<String, dynamic>?)?['text']
                as String? ??
            '';
        _durationText =
            (firstLeg['duration'] as Map<String, dynamic>?)?['text']
                as String? ??
            '';
        _routeStatus = _RouteStatus.success;
      });

      //  Draw immediately if map is ready, otherwise onMapCreated handles it
      if (_mapLoaded && _mapController != null) {
        _drawPolyline(points);
      }
    } on DioException catch (e) {
      if (!mounted) {
        return;
      }
      setState(() {
        _routeError = switch (e.type) {
          DioExceptionType.connectionTimeout => 'Connection timed out',
          DioExceptionType.receiveTimeout => 'Server took too long',
          DioExceptionType.connectionError => 'No internet connection',
          _ => 'Network error: ${e.message}',
        };
        _routeStatus = _RouteStatus.error;
      });
    } catch (e) {
      if (!mounted) {
        return;
      }
      setState(() {
        _routeError = e.toString();
        _routeStatus = _RouteStatus.error;
      });
    }
  }

  // ─── Polyline ─────────────────────────────────────────────────────────────────

  List<LatLng> _decodePolyline(String encoded) {
    final List<LatLng> result = <LatLng>[];
    int index = 0;
    int lat = 0;
    int lng = 0;

    while (index < encoded.length) {
      int shift = 0;
      int b;
      int value = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        value |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      lat += (value & 1) != 0 ? ~(value >> 1) : (value >> 1);

      shift = 0;
      value = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        value |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      lng += (value & 1) != 0 ? ~(value >> 1) : (value >> 1);

      result.add(LatLng(lat / 1E5, lng / 1E5));
    }

    return result;
  }

  void _drawPolyline(List<LatLng> points) {
    if (!mounted || _mapController == null || points.length < 2) {
      return;
    }

    setState(() {
      _polylines = <Polyline>{
        Polyline(
          polylineId: const PolylineId('route'),
          points: List<LatLng>.from(points),
          color: Colors.yellowAccent,
          width: 5,
          geodesic: true,
        ),
      };
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _fitCamera(points);
      }
    });
  }

  void _fitCamera(List<LatLng> points) {
    if (_mapController == null || points.length < 2) {
      return;
    }

    double south = points[0].latitude;
    double north = points[0].latitude;
    double west = points[0].longitude;
    double east = points[0].longitude;

    for (final LatLng p in points) {
      if (p.latitude < south) {
        south = p.latitude;
      }
      if (p.latitude > north) {
        north = p.latitude;
      }
      if (p.longitude < west) {
        west = p.longitude;
      }
      if (p.longitude > east) {
        east = p.longitude;
      }
    }

    _mapController!.animateCamera(
      CameraUpdate.newLatLngBounds(
        LatLngBounds(
          southwest: LatLng(south, west),
          northeast: LatLng(north, east),
        ),
        60,
      ),
    );
  }

  // ─── Build ───────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        showBackBtn: true,
        title: widget.isPickupLeg ? 'Pickup Route' : 'Delivery Route',
        titleAlignment: TitleAlignment.left,
        actions: <Widget>[
          if (_routeStatus == _RouteStatus.success)
            IconButton(
              icon: const Icon(Icons.info_outline_rounded),
              onPressed: _showRouteInfo,
            ),
        ],
      ),
      body: switch (_permissionStatus) {
        _PermissionStatus.checking => const _CenteredMessage(
          message: 'Checking location permission...',
        ),
        _PermissionStatus.denied => _ActionMessage(
          icon: Icons.location_off_rounded,
          message:
              'Location permission is needed to show your position on the map.',
          buttonLabel: 'Grant Permission',
          onTap: _checkPermission,
        ),
        _PermissionStatus.permanentlyDenied => const _ActionMessage(
          icon: Icons.location_disabled_rounded,
          message:
              'Location permission was permanently denied. Enable it in Settings.',
          buttonLabel: 'Open Settings',
          onTap: openAppSettings,
        ),
        _PermissionStatus.granted => _buildMapView(),
      },
    );
  }

  Widget _buildMapView() {
    return Stack(
      children: <Widget>[
        GoogleMap(
          initialCameraPosition: _initialCameraPosition,
          markers: _markers,
          polylines: _polylines,
          trafficEnabled: _showTraffic,
          myLocationEnabled: true,
          myLocationButtonEnabled: false,
          zoomControlsEnabled: false,
          mapToolbarEnabled: false,
          compassEnabled: true,
          onMapCreated: (GoogleMapController controller) {
            _mapController = controller;
            setState(() => _mapLoaded = true);

            //  Trigger fetch now that map is confirmed ready
            _fetchRoute();
          },
        ),

        // Map tiles still loading
        if (!_mapLoaded)
          Container(
            color: Colors.grey[200],
            child: const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            ),
          ),

        // Route calculating
        if (_routeStatus == _RouteStatus.loading)
          const Positioned(
            top: 16,
            left: 0,
            right: 0,
            child: _RouteLoadingBadge(),
          ),

        // Route error
        if (_routeStatus == _RouteStatus.error)
          Positioned(
            top: 16,
            left: 16,
            right: 16,
            child: _RouteErrorBanner(
              message: _routeError,
              onRetry: _fetchRoute,
            ),
          ),

        // Map controls
        Positioned(
          bottom: 120,
          right: 16,
          child: Column(
            children: <Widget>[
              _MapButton(
                icon: _showTraffic ? Icons.traffic : Icons.traffic_outlined,
                isActive: _showTraffic,
                onTap: () => setState(() => _showTraffic = !_showTraffic),
              ),
              const SizedBox(height: 8),
              _MapButton(
                icon: Icons.add_rounded,
                onTap: () =>
                    _mapController?.animateCamera(CameraUpdate.zoomIn()),
              ),
              const SizedBox(height: 8),
              _MapButton(
                icon: Icons.remove_rounded,
                onTap: () =>
                    _mapController?.animateCamera(CameraUpdate.zoomOut()),
              ),
              const SizedBox(height: 8),
              _MapButton(
                icon: Icons.my_location_rounded,
                onTap: () => _mapController?.animateCamera(
                  CameraUpdate.newCameraPosition(_initialCameraPosition),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ─── Bottom sheets ────────────────────────────────────────────────────────────

  void _showLocationSheet(String title, String address, LatLng location) {
    showModalBottomSheet<Container>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => Container(
        margin: const EdgeInsets.all(16),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.2),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.location_on_rounded,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(title, style: AppTextStyles.heading4),
                      Text(
                        '${location.latitude.toStringAsFixed(4)}, '
                        '${location.longitude.toStringAsFixed(4)}',
                        style: const TextStyle(
                          fontSize: 11,
                          color: AppColors.body,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close_rounded),
                  onPressed: () => Navigator.pop(context),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              address,
              style: AppTextStyles.paragraph1.copyWith(color: AppColors.body),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () async {
                  await Clipboard.setData(ClipboardData(text: address));
                  if (mounted) {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('✓ Address copied'),
                        behavior: SnackBarBehavior.floating,
                        duration: Duration(seconds: 2),
                      ),
                    );
                  }
                },
                icon: const Icon(Icons.copy_rounded, size: 18),
                label: const Text('Copy Address'),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showRouteInfo() {
    showModalBottomSheet<Container>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => Container(
        margin: const EdgeInsets.all(16),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Row(
              children: <Widget>[
                Icon(
                  widget.isPickupLeg
                      ? Icons.local_shipping
                      : Icons.delivery_dining,
                  color: widget.isPickupLeg ? AppColors.primary : Colors.orange,
                ),
                const SizedBox(width: 12),
                Text(
                  widget.isPickupLeg ? 'Pickup Route' : 'Delivery Route',
                  style: AppTextStyles.heading4,
                ),
              ],
            ),
            const SizedBox(height: 16),
            _InfoRow(
              label: 'Distance',
              value: _distanceText.isNotEmpty
                  ? _distanceText
                  : '${widget.job.distanceKm.toStringAsFixed(1)} km',
            ),
            _InfoRow(
              label: 'Est. Time',
              value: _durationText.isNotEmpty
                  ? _durationText
                  : '~${(widget.job.distanceKm / 25 * 60).round()} min',
            ),
            _InfoRow(
              label: 'Order ID',
              value: '#${widget.job.id.substring(0, 8)}',
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Close'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Private widgets ──────────────────────────────────────────────────────────

class _CenteredMessage extends StatelessWidget {
  final String message;
  const _CenteredMessage({required this.message});

  @override
  Widget build(BuildContext context) => Center(
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        const CircularProgressIndicator(color: AppColors.primary),
        const SizedBox(height: 16),
        Text(message, style: const TextStyle(color: AppColors.body)),
      ],
    ),
  );
}

class _ActionMessage extends StatelessWidget {
  final IconData icon;
  final String message;
  final String buttonLabel;
  final VoidCallback onTap;

  const _ActionMessage({
    required this.icon,
    required this.message,
    required this.buttonLabel,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) => Center(
    child: Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Icon(icon, size: 64, color: AppColors.body),
          const SizedBox(height: 16),
          Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(color: AppColors.body),
          ),
          const SizedBox(height: 24),
          ElevatedButton(onPressed: onTap, child: Text(buttonLabel)),
        ],
      ),
    ),
  );
}

class _RouteLoadingBadge extends StatelessWidget {
  const _RouteLoadingBadge();

  @override
  Widget build(BuildContext context) => Center(
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.black54,
        borderRadius: BorderRadius.circular(20),
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          SizedBox(
            width: 16,
            height: 16,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: Colors.white,
            ),
          ),
          SizedBox(width: 8),
          Text(
            'Calculating route...',
            style: TextStyle(color: Colors.white, fontSize: 12),
          ),
        ],
      ),
    ),
  );
}

class _RouteErrorBanner extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;
  const _RouteErrorBanner({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) => Material(
    color: Colors.white,
    borderRadius: BorderRadius.circular(12),
    elevation: 4,
    child: Padding(
      padding: const EdgeInsets.all(12),
      child: Row(
        children: <Widget>[
          Icon(Icons.error_outline, color: Colors.red[400]),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              message,
              style: TextStyle(color: Colors.red[800], fontSize: 13),
            ),
          ),
          TextButton(onPressed: onRetry, child: const Text('Retry')),
        ],
      ),
    ),
  );
}

class _MapButton extends StatelessWidget {
  final IconData icon;
  final bool isActive;
  final VoidCallback onTap;

  const _MapButton({
    required this.icon,
    required this.onTap,
    this.isActive = false,
  });

  @override
  Widget build(BuildContext context) => Material(
    color: Colors.white,
    borderRadius: BorderRadius.circular(8),
    elevation: 2,
    child: InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: isActive ? AppColors.primary : Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          icon,
          color: isActive ? Colors.white : AppColors.body,
          size: 24,
        ),
      ),
    ),
  );
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 8),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(label, style: const TextStyle(color: AppColors.body)),
        Text(value, style: const TextStyle(fontWeight: FontWeight.w600)),
      ],
    ),
  );
}
