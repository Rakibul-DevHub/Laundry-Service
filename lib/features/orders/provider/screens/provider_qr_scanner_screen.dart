// features/riders/jobs/screens/qr_scanner_screen.dart

import 'package:drop_n_fresh/app/toast/toast.dart';
import 'package:drop_n_fresh/core/extensions/context_extensions.dart';
import 'package:drop_n_fresh/features/orders/provider/models/order_status_type.dart';
import 'package:drop_n_fresh/features/orders/provider/notifier/orders_notifier.dart';
import 'package:drop_n_fresh/features/orders/provider/providers/order_providers.dart';
import 'package:drop_n_fresh/shared/widgets/dashed_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../../../../core/config/colors.dart';
import '../../../../shared/widgets/custom_app_bar.dart';

class ProviderQrScannerScreen extends ConsumerStatefulWidget {
  final String orderId;
  final OrderStatusType status;

  const ProviderQrScannerScreen({
    super.key,
    required this.orderId,
    required this.status,
  });

  @override
  ConsumerState<ProviderQrScannerScreen> createState() =>
      _ProviderQrScannerScreenState();
}

class _ProviderQrScannerScreenState
    extends ConsumerState<ProviderQrScannerScreen> {
  MobileScannerController? _scannerController;
  String? _scannedCode;
  bool _isVerifying = false;

  @override
  void initState() {
    super.initState();
    _scannerController = MobileScannerController(
      detectionSpeed: DetectionSpeed.noDuplicates,
      formats: <BarcodeFormat>[BarcodeFormat.qrCode],
    );
  }

  @override
  void dispose() {
    _scannerController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Scan Bag QR Code',
        showBackBtn: true,
        titleAlignment: TitleAlignment.center,
      ),
      backgroundColor: Colors.black,
      body: Stack(
        children: <Widget>[
          //  Camera View
          MobileScanner(
            controller: _scannerController,
            onDetect: (BarcodeCapture capture) {
              final List<Barcode> barcodes = capture.barcodes;
              if (barcodes.isNotEmpty) {
                final String code = barcodes.first.rawValue ?? '';
                if (code.isNotEmpty && code != _scannedCode) {
                  //  Update scanned code but don't auto-verify
                  setState(() => _scannedCode = code);
                  debugPrint('📱 Scanned QR Code: $code');

                  //  Haptic feedback on scan
                  Feedback.forTap(context);
                }
              }
            },
            errorBuilder: (BuildContext context, MobileScannerException error) {
              return _buildErrorState(
                error.errorDetails?.message ?? "Something wrong with scanner",
              );
            },
          ),

          //  Scan Frame Overlay
          Positioned.fill(
            child: Center(
              child: DashedBorder(
                borderRadius: BorderRadius.circular(8),
                child: SizedBox(
                  width: context.screenWidth * .6,
                  height: context.screenWidth * .6,
                ),
              ),
            ),
          ),

          //  Instructions (show when no code scanned)
          if (_scannedCode == null)
            Positioned(
              top: 100,
              left: 0,
              right: 0,
              child: Column(
                children: <Widget>[
                  const Icon(
                    Icons.qr_code_scanner,
                    color: Colors.white,
                    size: 48,
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black54,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      'Align QR code within the frame',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),

          //  Scanned Code Display + Verify Button
          if (_scannedCode != null)
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: _buildVerifyPanel(),
            ),

          //  Verifying Overlay
          if (_isVerifying)
            Container(
              color: Colors.black54,
              child: const Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    SizedBox(
                      width: 40,
                      height: 40,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 3,
                      ),
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Verifying QR Code...',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  ///  Bottom panel: Show scanned code + Verify/Re scan buttons
  Widget _buildVerifyPanel() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          // Drag handle
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Scanned code display
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.grey50,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
            ),
            child: Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    const Icon(
                      Icons.qr_code_2_rounded,
                      color: AppColors.primary,
                      size: 24,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          const Text(
                            'Scanned Code',
                            style: TextStyle(
                              fontSize: 12,
                              color: AppColors.body,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            _scannedCode ?? '',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              fontFamily: 'monospace',
                            ),
                          ),
                        ],
                      ),
                    ),
                    //  Re scan button
                    IconButton(
                      onPressed: () {
                        setState(() => _scannedCode = null);
                        _scannerController?.stop();
                        _scannerController?.start();
                      },
                      icon: const Icon(Icons.refresh_rounded),
                      tooltip: 'Re scan',
                      color: AppColors.body,
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          //  Verify Button
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              onPressed: _isVerifying ? null : _verifyScannedCode,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: _isVerifying
                  ? const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.5,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(Icons.check_circle_rounded),
                        SizedBox(width: 8),
                        Text(
                          'Verify Bag',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
            ),
          ),

          const SizedBox(height: 12),

          //  Re scan text button
          TextButton(
            onPressed: () => setState(() {
              _scannedCode = null;
              _scannerController?.stop();
              _scannerController?.start();
            }),
            child: const Text(
              'Scan a different code',
              style: TextStyle(
                color: AppColors.body,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }

  ///  User tapped "Verify" - now call backend API
  Future<void> _verifyScannedCode() async {
    if (_scannedCode == null || _scannedCode!.isEmpty) {
      Toast.showWarning('Please scan a QR code first');
      return;
    }

    setState(() => _isVerifying = true);

    try {
      final OrdersNotifier notifier = ref.read(
        ordersProvider(widget.status).notifier,
      );

      await notifier.scanPickupBags(
        qrCode: _scannedCode!,
        orderId: widget.orderId,
      );

      //  Success
      if (mounted) {
        Toast.showSuccess('Bag verified successfully!');
        context.pop(_scannedCode); //  Return scanned code
      }
    } catch (e) {
      if (mounted) {
        Toast.showError('Failed to verify. Please try again.');
      }
    } finally {
      if (mounted) {
        setState(() => _isVerifying = false);
      }
    }
  }

  Widget _buildErrorState(String errorMessage) {
    return Container(
      color: Colors.black,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              Icons.camera_alt,
              color: Colors.red[400],
              size: 64,
            ),
            const SizedBox(height: 16),
            const Text(
              'Camera Error',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Text(
                errorMessage,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.grey[400],
                  fontSize: 14,
                ),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {
                _scannerController?.start();
                setState(() {});
              },
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
