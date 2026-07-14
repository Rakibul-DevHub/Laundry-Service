import 'dart:io';
import 'package:drop_n_fresh/core/utils/image_picker_utils.dart';
import 'package:drop_n_fresh/features/profile/model/documents/provider_verification_data.dart';
import 'package:drop_n_fresh/features/profile/providers/provider_documents_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/utils/app_logger.dart';
import '../../../../app/toast/toast.dart';

class ProviderDocumentsScreen extends ConsumerStatefulWidget {
  const ProviderDocumentsScreen({super.key});

  @override
  ConsumerState<ProviderDocumentsScreen> createState() =>
      _ProviderDocumentsScreenState();
}

class _ProviderDocumentsScreenState extends ConsumerState<ProviderDocumentsScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _tradeLicenseController = TextEditingController();
  final TextEditingController _nidController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  // Local state for picked files
  File? _tradeLicenseFile;
  File? _nidFrontFile;
  File? _nidBackFile;
  File? _shopPhotoFile;

  bool _isUploadingImages = false;

  @override
  void dispose() {
    _tradeLicenseController.dispose();
    _nidController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  /// Handles picking an image and updating the specific file state
  Future<void> _pickImage(void Function(File) onPicked) async {
    final File? pickedFile = await ImagePickerUtils.pickImageFile();
    if (pickedFile != null) {
      setState(() {
        onPicked(pickedFile);
      });
    }
  }

  /// IMPORTANT: This takes the local File and uploads it to your server to get a URL.
  /// You MUST implement your actual multipart upload API call here.
  Future<String> _uploadImageAndGetUrl(File file) async {
    try {
      // TODO: Replace this with your actual API upload request
      // Example:
      // final response = await ref.read(apiClientProvider).uploadFile(file);
      // return response.data['url'];

      await Future<void>.delayed(const Duration(seconds: 1)); // Mock delay
      return "https://example.com/mock-uploaded-image.jpg"; // Mock return
    } catch (e) {
      AppLogger().e("Image upload failed", error: e);
      throw Exception("Failed to upload image.");
    }
  }

  /// Handles the complete submission process
  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    // Validate that all required images are selected
    if (_tradeLicenseFile == null ||
        _nidFrontFile == null ||
        _nidBackFile == null ||
        _shopPhotoFile == null) {
      Toast.showError("Please upload all required document photos.");
      return;
    }

    setState(() => _isUploadingImages = true);

    try {
      // 1. Upload all local files to get their cloud URLs
      final String tradeUrl = await _uploadImageAndGetUrl(_tradeLicenseFile!);
      final String nidFrontUrl = await _uploadImageAndGetUrl(_nidFrontFile!);
      final String nidBackUrl = await _uploadImageAndGetUrl(_nidBackFile!);
      final String shopUrl = await _uploadImageAndGetUrl(_shopPhotoFile!);

      // 2. Submit the URLs and Text to the Notifier
      await ref.read(providerDocumentsProvider.notifier).submitDocuments(
        tradeLicenseNumber: _tradeLicenseController.text.trim(),
        tradeLicenseUrl: tradeUrl,
        nidNumber: _nidController.text.trim(),
        nidFrontUrl: nidFrontUrl,
        nidBackUrl: nidBackUrl,
        businessAddress: _addressController.text.trim(),
        shopPhotoUrl: shopUrl,
      );

      Toast.showSuccess("Documents submitted successfully!");
    } catch (e) {
      Toast.showError("Submission failed. Please try again.");
    } finally {
      if (mounted) {
        setState(() => _isUploadingImages = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final AsyncValue<ProviderVerificationData?> verificationState =
    ref.watch(providerDocumentsProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Business Verification',
          style: TextStyle(color: Colors.black, fontSize: 18),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: verificationState.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (Object err, StackTrace stack) =>
            Center(child: Text('Error: $err')),
        data: (ProviderVerificationData? data) {
          // 1. Pending Screen
          if (data != null && data.verificationStatus == 'pending') {
            return _buildStatusScreen(
              icon: Icons.hourglass_top,
              color: Colors.orange,
              title: 'Verification Pending',
              message: 'Your documents are currently under review.\nPlease wait for admin approval.',
            );
          }

          // 2. Approved Screen
          if (data != null && data.verificationStatus == 'approved') {
            return _buildStatusScreen(
              icon: Icons.check_circle,
              color: Colors.green,
              title: 'Account Verified!',
              message: 'You are approved to accept orders.',
            );
          }

          // 3. New Submission OR Rejected Form
          return _buildSubmissionForm(context, data?.rejectionReasons);
        },
      ),
    );
  }

  // ---- FORM BUILDER ---- //

  Widget _buildSubmissionForm(BuildContext context, List<String>? rejectionReasons) {
    final bool isRejected = rejectionReasons != null && rejectionReasons.isNotEmpty;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // Rejection Banner
            if (isRejected)
              Container(
                width: double.infinity,
                margin: const EdgeInsets.only(bottom: 20),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.red.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.red),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const Text(
                      'Verification Rejected',
                      style: TextStyle(
                          color: Colors.red, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    ...rejectionReasons.map((String reason) => Text(
                      '• $reason',
                      style: const TextStyle(color: Colors.red, fontSize: 13),
                    )),
                  ],
                ),
              ),

            const Text(
              'Business Information',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            // Text Fields
            TextFormField(
              controller: _tradeLicenseController,
              decoration: const InputDecoration(
                labelText: 'Trade License Number *',
                border: OutlineInputBorder(),
              ),
              validator: (String? value) =>
              value == null || value.isEmpty ? 'Required' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _nidController,
              decoration: const InputDecoration(
                labelText: 'NID Number *',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              validator: (String? value) =>
              value == null || value.isEmpty ? 'Required' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _addressController,
              decoration: const InputDecoration(
                labelText: 'Full Business Address *',
                border: OutlineInputBorder(),
              ),
              maxLines: 2,
              validator: (String? value) =>
              value == null || value.isEmpty ? 'Required' : null,
            ),

            const SizedBox(height: 32),
            const Text(
              'Document Photos',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            // Image Upload Slots
            _buildImagePickerSlot(
              title: 'Trade License Image',
              file: _tradeLicenseFile,
              onTap: () => _pickImage((File f) => _tradeLicenseFile = f),
            ),
            const SizedBox(height: 16),
            _buildImagePickerSlot(
              title: 'NID Front',
              file: _nidFrontFile,
              onTap: () => _pickImage((File f) => _nidFrontFile = f),
            ),
            const SizedBox(height: 16),
            _buildImagePickerSlot(
              title: 'NID Back',
              file: _nidBackFile,
              onTap: () => _pickImage((File f) => _nidBackFile = f),
            ),
            const SizedBox(height: 16),
            _buildImagePickerSlot(
              title: 'Shop/Storefront Photo',
              file: _shopPhotoFile,
              onTap: () => _pickImage((File f) => _shopPhotoFile = f),
            ),

            const SizedBox(height: 40),

            // Submit Button
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: _isUploadingImages ? null : _submitForm,
                child: _isUploadingImages
                    ? const SizedBox(
                  height: 24,
                  width: 24,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2,
                  ),
                )
                    : const Text(
                  'Submit Verification',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // ---- WIDGET HELPERS ---- //

  Widget _buildImagePickerSlot({
    required String title,
    required File? file,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: double.infinity,
        height: 140,
        decoration: BoxDecoration(
          color: Colors.grey.withValues(alpha: 0.05),
          border: Border.all(
            color: file != null ? Colors.green : Colors.grey.withValues(alpha: 0.5),
            width: 1.5,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: file != null
            ? ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Image.file(file, fit: BoxFit.cover, width: double.infinity),
        )
            : Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Icon(Icons.add_a_photo_outlined, size: 32, color: Colors.grey),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(
                  color: Colors.grey, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 4),
            const Text(
              'Tap to upload',
              style: TextStyle(color: Colors.grey, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusScreen({
    required IconData icon,
    required Color color,
    required String title,
    required String message,
  }) {
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(icon, size: 80, color: color),
            const SizedBox(height: 24),
            Text(
              title,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.grey, fontSize: 16, height: 1.4),
            ),
          ],
        ),
      ),
    );
  }
}