// update_location_screen.dart

import 'package:drop_n_fresh/app/toast/toast.dart';
import 'package:drop_n_fresh/shared/widgets/app_elevated_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; //  For HapticFeedback
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../../core/utils/app_logger.dart';
import '../../../core/config/colors.dart';

class UpdateLocationScreen extends ConsumerStatefulWidget {
  const UpdateLocationScreen({super.key});

  @override
  ConsumerState<UpdateLocationScreen> createState() =>
      _UpdateLocationScreenState();
}

class _UpdateLocationScreenState extends ConsumerState<UpdateLocationScreen> {
  GoogleMapController? _mapController;
  LatLng _currentPosition = const LatLng(37.7749, -122.4194);
  bool _isLoading = true;
  bool _isGettingCurrentLocation = false;
  String address = "";

  BitmapDescriptor? _customMarkerIcon;

  @override
  void initState() {
    super.initState();
    _createCustomMarkerIcon();
    _initializeMap();
  }

  Future<void> _createCustomMarkerIcon() async {
    _customMarkerIcon = BitmapDescriptor.defaultMarkerWithHue(
      BitmapDescriptor.hueViolet,
    );
    if (mounted) {
      setState(() {});
    }
  }

  Future<void> _initializeMap() async {
    try {
      await _requestPermissions();
      await _getCurrentLocation();
    } catch (e) {
      AppLogger().e('Map initialization error: $e');
      if (mounted) {
        Toast.showError("Failed to initialize map");
      }
    }
  }

  Future<void> _requestPermissions() async {
    final PermissionStatus status = await Permission.locationWhenInUse.status;

    if (status.isGranted) {
      await _getCurrentLocation();
      return;
    }

    if (status.isPermanentlyDenied) {
      if (mounted) {
        _showPermissionDialog();
      }
      return;
    }

    final PermissionStatus requestStatus = await Permission.locationWhenInUse
        .request();

    if (requestStatus.isGranted) {
      await _getCurrentLocation();
    } else if (requestStatus.isPermanentlyDenied) {
      if (mounted) {
        _showPermissionDialog();
      }
    } else {
      if (mounted) {
        _showPermissionDialog();
      }
    }
  }

  void _showPermissionDialog() {
    showDialog<AlertDialog>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Location Permission Required'),
        content: const Text(
          'Please enable location permission to use this feature.',
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () => context.pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              await openAppSettings();
              if (mounted) {
                context.pop();
              }
            },
            child: const Text('Settings'),
          ),
        ],
      ),
    );
  }

  Future<void> _getCurrentLocation() async {
    if (!mounted) {
      return;
    }

    setState(() => _isGettingCurrentLocation = true);

    try {
      final bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        if (mounted) {
          Toast.showWarning("Please enable location services");
        }
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        if (mounted) {
          Toast.showError("Location permission permanently denied");
        }
        return;
      }

      final Position position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          timeLimit: Duration(seconds: 10),
        ),
      );

      if (!mounted) {
        return;
      }

      setState(() {
        _currentPosition = LatLng(position.latitude, position.longitude);
        _isLoading = false;
      });

      _mapController?.animateCamera(
        CameraUpdate.newLatLngZoom(_currentPosition, 15),
      );

      await _getAddressFromLatLng(_currentPosition);
    } catch (e) {
      AppLogger().e('Error getting location: $e');
      if (!mounted) {
        return;
      }

      setState(() => _isLoading = false);

      Toast.showError(
        "Unable to get current location. Please select manually.",
      );
    } finally {
      if (mounted) {
        setState(() => _isGettingCurrentLocation = false);
      }
    }
  }

  Future<void> _getAddressFromLatLng(LatLng position) async {
    try {
      final List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (placemarks.isNotEmpty && mounted) {
        final Placemark place = placemarks.first;
        setState(() {
          address =
              '${place.street}, ${place.locality}, ${place.administrativeArea}';
        });
      }
    } catch (e) {
      AppLogger().e('Error getting address: $e');
      if (mounted) {
        setState(() {
          address = 'Lat: ${position.latitude}, Lng: ${position.longitude}';
        });
      }
    }
  }

  void _onMarkerTap() {
    HapticFeedback.selectionClick();
  }

  void _onDragStart(LatLng position) {
    HapticFeedback.lightImpact();
  }

  Future<void> _onDragEnd(LatLng newPosition) async {
    if (!mounted) {
      return;
    }

    setState(() {
      _currentPosition = newPosition;
    });

    HapticFeedback.mediumImpact();

    await _getAddressFromLatLng(newPosition);
  }

  void _onMapTapped(LatLng position) {
    if (!mounted) {
      return;
    }
    setState(() => _currentPosition = position);
    _getAddressFromLatLng(position);

    _mapController?.animateCamera(
      CameraUpdate.newLatLngZoom(position, 15),
    );
  }

  void _onCameraMove(CameraPosition position) {
    if (!mounted) {
      return;
    }
    setState(() {
      _currentPosition = position.target;
    });
  }

  void _confirmLocation() {
    if (mounted) {
      context.pop(<String, Object>{
        "lat": _currentPosition.latitude,
        "long": _currentPosition.longitude,
        "address": address,
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: Stack(
        children: <Widget>[
          GoogleMap(
            mapType: MapType.normal,
            initialCameraPosition: CameraPosition(
              target: _currentPosition,
              zoom: 14,
            ),
            onMapCreated: (GoogleMapController controller) {
              _mapController = controller;
            },
            onCameraMove: _onCameraMove,
            onTap: _onMapTapped,
            markers: <Marker>{
              Marker(
                markerId: const MarkerId('selected_location'),
                position: _currentPosition,
                icon:
                    _customMarkerIcon ??
                    BitmapDescriptor.defaultMarkerWithHue(
                      BitmapDescriptor.hueRed,
                    ),
                anchor: const Offset(0.5, 1.0),
                draggable: true,
                infoWindow: InfoWindow(
                  title: 'Selected Location',
                  snippet: address.isNotEmpty ? address : 'Drag to update',
                  onTap: _onMarkerTap,
                ),
                onTap: _onMarkerTap,
                onDragStart: _onDragStart,
                onDragEnd: _onDragEnd,
              ),
            },
            myLocationEnabled: true,
            myLocationButtonEnabled: false,
            zoomControlsEnabled: false,
            zoomGesturesEnabled: true,
            mapToolbarEnabled: false,
            tiltGesturesEnabled: false,
            rotateGesturesEnabled: true,
            scrollGesturesEnabled: true,
          ),

          // Current Location Button
          Positioned(
            right: 16,
            bottom: 100,
            child: FloatingActionButton(
              mini: true,
              backgroundColor: AppColors.paste300,
              onPressed: _isGettingCurrentLocation ? null : _getCurrentLocation,
              child: _isGettingCurrentLocation
                  ? const SizedBox(
                      width: 32,
                      height: 32,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Icon(
                      Icons.my_location,
                      color: Colors.white,
                      size: 32,
                    ),
            ),
          ),

          // Loading Overlay
          if (_isLoading)
            Container(
              color: Colors.black54,
              child: const Center(
                child: CircularProgressIndicator(
                  color: AppColors.paste300,
                ),
              ),
            ),

          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: SafeArea(
              child: Container(
                color: Colors.transparent,
                child: Row(
                  children: <Widget>[
                    IconButton(
                      onPressed: () => context.pop(),
                      icon: const Icon(
                        Icons.arrow_back,
                        size: 32,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          Positioned(
            right: 0,
            left: 0,
            bottom: 0,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                boxShadow: <BoxShadow>[
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 10,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: AppElevatedButton(
                label: "Confirm Location",
                onPressed: _confirmLocation,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
