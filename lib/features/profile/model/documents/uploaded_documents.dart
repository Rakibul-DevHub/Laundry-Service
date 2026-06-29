class UploadedDocument {
  final String filename;
  final String originalName;
  final String filePath;
  final String url;
  final int fileSize;
  final String mimeType;
  final String provider;
  final DateTime uploadedAt;

  UploadedDocument({
    required this.filename,
    required this.originalName,
    required this.filePath,
    required this.url,
    required this.fileSize,
    required this.mimeType,
    required this.provider,
    required this.uploadedAt,
  });

  factory UploadedDocument.fromJson(Map<String, dynamic> json) {
    return UploadedDocument(
      filename: json['filename'] as String,
      originalName: json['originalName'] as String,
      filePath: json['filePath'] as String,
      url: json['url'] as String,
      fileSize: (json['fileSize'] as num).toInt(),
      mimeType: json['mimeType'] as String,
      provider: json['provider'] as String,
      uploadedAt: DateTime.parse(json['uploadedAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'filename': filename,
      'originalName': originalName,
      'filePath': filePath,
      'url': url,
      'fileSize': fileSize,
      'mimeType': mimeType,
      'provider': provider,
      'uploadedAt': uploadedAt.toIso8601String(),
    };
  }
}
