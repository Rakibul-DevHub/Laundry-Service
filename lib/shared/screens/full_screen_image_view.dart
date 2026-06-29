// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:photo_view/photo_view.dart';
// import '../../utils/detect_image_type.dart';
// import 'package:cached_network_image/cached_network_image.dart'; // Optional but recommended

// class FullScreenImageScreen extends StatefulWidget {
//   final dynamic imagePath;

//   const FullScreenImageScreen({super.key, this.imagePath});

//   @override
//   State<FullScreenImageScreen> createState() => _FullScreenImageScreenState();
// }

// class _FullScreenImageScreenState extends State<FullScreenImageScreen> {
//   bool _showControls = true;

//   @override
//   Widget build(BuildContext context) {
//     final ImageType imageType = DetectImageType.detectImageType(
//       widget.imagePath,
//     );
//     late ImageProvider imageProvider;

//     // Handle unsupported types gracefully
//     if (imageType == ImageType.svgAsset) {
//       return Scaffold(
//         backgroundColor: Colors.black,
//         body: Center(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: <Widget>[
//               const Icon(
//                 Icons.image_not_supported,
//                 size: 64,
//                 color: Colors.white54,
//               ),
//               const SizedBox(height: 16),
//               Text(
//                 'SVG preview not supported',
//                 style: Theme.of(
//                   context,
//                 ).textTheme.bodyMedium?.copyWith(color: Colors.white70),
//               ),
//             ],
//           ),
//         ),
//       );
//     }

//     try {
//       imageProvider = switch (imageType) {
//         ImageType.asset => AssetImage(widget.imagePath as String),
//         ImageType.network => CachedNetworkImageProvider(
//           widget.imagePath as String,
//         ), // Better than NetworkImage
//         ImageType.file => FileImage(widget.imagePath as File),
//         _ => const AssetImage('assets/images/placeholder.png'), // fallback
//       };
//     } catch (e) {
//       return _buildErrorScreen(context);
//     }

//     return Scaffold(
//       backgroundColor: Colors.black,
//       body: Stack(
//         children: <Widget>[
//           // Main PhotoView
//           PhotoView(
//             imageProvider: imageProvider,
//             backgroundDecoration: const BoxDecoration(color: Colors.black),
//             minScale: PhotoViewComputedScale.contained * 0.8,
//             maxScale: PhotoViewComputedScale.covered * 4,
//             enableRotation: true,
//             filterQuality: FilterQuality.high,
//             loadingBuilder: (BuildContext context, ImageChunkEvent? event) =>
//                 _buildLoadingIndicator(context),
//             errorBuilder:
//                 (BuildContext context, Object error, StackTrace? stackTrace) =>
//                     _buildErrorScreen(context),
//             onTapUp: (_, _, _) {
//               // Toggle controls on tap
//               setState(() {
//                 _showControls = !_showControls;
//               });
//             },
//           ),

//           // Top App Bar (close button)
//           if (_showControls)
//             Positioned(
//               top: MediaQuery.of(context).padding.top,
//               left: 16,
//               right: 16,
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: <Widget>[
//                   _buildCloseButton(context),
//                 ],
//               ),
//             ),
//         ],
//       ),
//     );
//   }

//   Widget _buildCloseButton(BuildContext context) {
//     return Container(
//       decoration: const BoxDecoration(
//         color: Colors.black54,
//         shape: BoxShape.circle,
//       ),
//       child: IconButton(
//         icon: const Icon(Icons.close, color: Colors.white, size: 28),
//         onPressed: () => Navigator.of(context).pop(),
//         padding: const EdgeInsets.all(8),
//         splashRadius: 24,
//       ),
//     );
//   }

//   Widget _buildLoadingIndicator(BuildContext context) {
//     return Container(
//       color: Colors.black,
//       child: const Center(
//         child: CircularProgressIndicator(color: Colors.blue),
//       ),
//     );
//   }

//   Widget _buildErrorScreen(BuildContext context) {
//     return Container(
//       color: Colors.black,
//       child: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             const Icon(Icons.broken_image, size: 64, color: Colors.white54),
//             const SizedBox(height: 16),
//             Text(
//               'Failed to load image',
//               style: Theme.of(
//                 context,
//               ).textTheme.bodyMedium?.copyWith(color: Colors.white70),
//             ),
//             const SizedBox(height: 16),
//             TextButton.icon(
//               onPressed: () => Navigator.of(context).pop(),
//               icon: const Icon(Icons.arrow_back, color: Colors.white),
//               label: const Text(
//                 'Go Back',
//                 style: TextStyle(color: Colors.white),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
