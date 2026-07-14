class ProviderVerificationData {
  final String verificationStatus;
  final List<VerificationDocument> businessDocuments;
  final List<VerificationDocument> businessGallery;
  final DateTime? submittedAt;
  final List<String> rejectionReasons;

  ProviderVerificationData({
    required this.verificationStatus,
    required this.businessDocuments,
    required this.businessGallery,
    this.submittedAt,
    required this.rejectionReasons,
  });

  factory ProviderVerificationData.fromJson(Map<String, dynamic> json) {
    return ProviderVerificationData(
      verificationStatus: json['verificationStatus'] as String? ?? 'unsubmitted',
      businessDocuments: (json['businessDocuments'] as List<dynamic>? ?? <dynamic>[])
          .map((e) => VerificationDocument.fromJson(e as Map<String, dynamic>))
          .toList(),
      businessGallery: (json['businessGallery'] as List<dynamic>? ?? <dynamic>[])
          .map((e) => VerificationDocument.fromJson(e as Map<String, dynamic>))
          .toList(),
      submittedAt: json['submittedAt'] != null ? DateTime.tryParse(json['submittedAt'] as String) : null,
      rejectionReasons: (json['rejectionReasons'] as List<dynamic>? ?? <dynamic>[])
          .map((e) => e.toString())
          .toList(),
    );
  }
}

class VerificationDocument {
  final String filename;
  final String url;
  final String status;
  final DateTime? uploadedAt;

  VerificationDocument({
    required this.filename,
    required this.url,
    required this.status,
    this.uploadedAt,
  });

  factory VerificationDocument.fromJson(Map<String, dynamic> json) {
    return VerificationDocument(
      filename: json['filename'] as String? ?? '',
      url: json['url'] as String? ?? '',
      status: json['status'] as String? ?? '',
      uploadedAt: json['uploadedAt'] != null ? DateTime.tryParse(json['uploadedAt'] as String) : null,
    );
  }
}