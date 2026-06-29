import 'dart:io';

import 'package:flutter/material.dart';

import '../../../shared/widgets/asset_loader.dart';

class DocumentImagePreview extends StatelessWidget {
  final File imageFile;
  final VoidCallback onRemove;

  const DocumentImagePreview({
    super.key,
    required this.imageFile,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: AssetLoader(
            assetPath: imageFile,
            height: 150,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
        ),
        Positioned(
          top: 8,
          right: 8,
          child: GestureDetector(
            onTap: onRemove,
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: const BoxDecoration(
                color: Colors.red,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.close,
                color: Colors.white,
                size: 16,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
