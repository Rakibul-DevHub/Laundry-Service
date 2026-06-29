// features/home/widgets/banner_item.dart

import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import '../models/banner_model.dart';

class BannerItem extends StatefulWidget {
  final BannerModel banner;
  final double height;

  const BannerItem({
    super.key,
    required this.banner,
    this.height = 200,
  });

  @override
  State<BannerItem> createState() => _BannerItemState();
}

class _BannerItemState extends State<BannerItem> {
  VideoPlayerController? _videoController;
  bool _isVideoPlaying = false;
  bool _isVideoInitialized = false;
  bool _hasVideoError = false;
  bool _showControls = true; //  Show controls by default
  bool _isMuted = true; //  Track mute state separately
  Timer? _initTimeout;
  Timer? _controlsTimeout;

  @override
  void initState() {
    super.initState();
    if (widget.banner.isVideo) {
      _isMuted = widget.banner.muted; //  Start with API mute setting
      _initializeVideo();
    } else {
      setState(() => _isVideoInitialized = true);
    }
  }

  Future<void> _initializeVideo() async {
    _initTimeout = Timer(const Duration(seconds: 10), () {
      if (!_isVideoInitialized && mounted) {
        setState(() {
          _hasVideoError = true;
          _isVideoInitialized = true;
        });
      }
    });

    try {
      debugPrint('🎬 Initializing video: ${widget.banner.mediaUrl}');

      _videoController = VideoPlayerController.networkUrl(
        Uri.parse(widget.banner.mediaUrl),
      );

      await _videoController?.initialize().timeout(
        const Duration(seconds: 8),
        onTimeout: () =>
            throw TimeoutException('Video initialization timed out'),
      );

      debugPrint('✅ Video initialized successfully');

      if (mounted && _videoController != null) {
        _initTimeout?.cancel();

        setState(() {
          _isVideoInitialized = true;
          _hasVideoError = false;
        });

        //  Apply initial mute state
        await _videoController?.setVolume(_isMuted ? 0 : 1);

        if (widget.banner.autoPlay) {
          try {
            await _videoController?.play();
            if (widget.banner.loop) {
              _videoController?.setLooping(true);
            }
            if (mounted) {
              setState(() {
                _isVideoPlaying = true;
                _showControls = false; // Hide controls when auto-playing
              });
            }
          } catch (playError) {
            debugPrint('⚠️ Auto-play failed: $playError');
            if (mounted) {
              setState(() => _showControls = true);
            }
          }
        }
      }
    } catch (e) {
      debugPrint('❌ Video initialization error: $e');
      _initTimeout?.cancel();

      if (mounted) {
        setState(() {
          _hasVideoError = true;
          _isVideoInitialized = true;
        });
      }
    }
  }

  @override
  void dispose() {
    _initTimeout?.cancel();
    _controlsTimeout?.cancel();
    _videoController?.pause();
    _videoController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.height,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(12),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: _buildMediaContent(),
      ),
    );
  }

  Widget _buildMediaContent() {
    if (widget.banner.isVideo) {
      if (!_isVideoInitialized && !_hasVideoError) {
        return _buildLoadingState();
      }

      if (_hasVideoError || !_isVideoInitialized) {
        return _buildErrorState();
      }

      return _buildVideoPlayer();
    }

    return _buildImageBanner();
  }

  ///  Loading state
  Widget _buildLoadingState() {
    return Stack(
      fit: StackFit.expand,
      children: <Widget>[
        _buildThumbnail(),
        Container(color: Colors.black26),
        const Center(
          child: SizedBox(
            width: 32,
            height: 32,
            child: CircularProgressIndicator(
              strokeWidth: 2.5,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          ),
        ),
      ],
    );
  }

  ///  Error state with retry
  Widget _buildErrorState() {
    return Stack(
      fit: StackFit.expand,
      children: <Widget>[
        _buildThumbnail(),
        Container(color: Colors.black26),
        Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.95),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.play_arrow,
                  color: Colors.black,
                  size: 40,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Tap to play',
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.95),
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        Positioned.fill(
          child: GestureDetector(
            onTap: _handleVideoTap,
            behavior: HitTestBehavior.opaque,
            child: Container(color: Colors.transparent),
          ),
        ),
      ],
    );
  }

  ///  Video player with FIXED controls
  Widget _buildVideoPlayer() {
    return Stack(
      fit: StackFit.expand,
      children: <Widget>[
        //  Video player - absorb all touches so controls work on top
        AbsorbPointer(
          absorbing: true, //  Critical: Prevent VideoPlayer from capturing taps
          child: VideoPlayer(_videoController!),
        ),

        //  Tap anywhere to toggle controls visibility
        Positioned.fill(
          child: GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: _toggleControls,
            child: Container(color: Colors.transparent),
          ),
        ),

        //  Controls overlay (play/pause + mute)
        if (_showControls) _buildControlsOverlay(),

        //  Auto-hide controls after 3 seconds of playback
        if (_isVideoPlaying && _showControls)
          TimerWidget(
            duration: const Duration(seconds: 3),
            onTimeout: () {
              if (mounted && _isVideoPlaying) {
                setState(() => _showControls = false);
              }
            },
          ),
      ],
    );
  }

  Widget _buildControlsOverlay() {
    return IgnorePointer(
      ignoring: false,
      child: GestureDetector(
        onTap: _togglePlayPause,
        child: Container(
          color: Colors.transparent,
          child: Stack(
            fit: StackFit.expand,
            children: <Widget>[
              // Center(
              //   child: GestureDetector(
              //     onTapDown: (_) =>
              //         _showControls, // Prevent auto-hide on button tap
              //     onTap: _togglePlayPause,
              //     behavior: HitTestBehavior.opaque,
              //     child: AnimatedContainer(
              //       duration: const Duration(milliseconds: 200),
              //       width: 72,
              //       height: 72,
              //       decoration: BoxDecoration(
              //         color: Colors.white.withValues(alpha: 0.92),
              //         shape: BoxShape.circle,
              //         boxShadow: <BoxShadow>[
              //           BoxShadow(
              //             color: Colors.black.withValues(alpha: 0.25),
              //             blurRadius: 12,
              //             offset: const Offset(0, 4),
              //           ),
              //         ],
              //       ),
              //       child: Icon(
              //         _isVideoPlaying
              //             ? Icons.pause_rounded
              //             : Icons.play_arrow_rounded,
              //         color: Colors.black87,
              //         size: 44,
              //       ),
              //     ),
              //   ),
              // ),
              Positioned(
                top: 8,
                right: 8,
                child: GestureDetector(
                  onTapDown: (_) => _showControls,
                  onTap: _toggleMute,
                  behavior: HitTestBehavior.opaque,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black54,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Icon(
                          _isMuted
                              ? Icons.volume_off_rounded
                              : Icons.volume_up_rounded,
                          color: Colors.white,
                          size: 20,
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              //  Bottom: Subtle gradient for contrast
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                height: 60,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: <Color>[
                        Colors.black.withValues(alpha: 0.2),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImageBanner() {
    return CachedNetworkImage(
      imageUrl: widget.banner.mediaUrl,
      fit: BoxFit.cover,
      placeholder: (BuildContext context, String url) => Container(
        color: Colors.grey[300],
        child: const Center(
          child: SizedBox(
            width: 24,
            height: 24,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
        ),
      ),
      errorWidget: (BuildContext context, String url, Object error) {
        debugPrint('❌ Image load error: $error');
        return _buildErrorPlaceholder();
      },
    );
  }

  Widget _buildThumbnail() {
    if (widget.banner.hasThumbnail) {
      return CachedNetworkImage(
        imageUrl: widget.banner.thumbnailUrl!,
        fit: BoxFit.cover,
        errorWidget: (BuildContext context, String url, Object error) =>
            _buildErrorPlaceholder(),
      );
    }
    return _buildErrorPlaceholder();
  }

  Widget _buildErrorPlaceholder() {
    return Container(
      color: Colors.grey[300],
      child: const Center(
        child: Icon(Icons.broken_image_outlined, color: Colors.grey, size: 48),
      ),
    );
  }

  //  Toggle controls visibility
  void _toggleControls() {
    setState(() {
      _showControls = !_showControls;
      // Reset auto-hide timer when controls shown
      if (_showControls && _isVideoPlaying) {
        _controlsTimeout?.cancel();
        _controlsTimeout = Timer(const Duration(seconds: 3), () {
          if (mounted && _isVideoPlaying) {
            setState(() => _showControls = false);
          }
        });
      }
    });
  }

  //  Toggle play/pause - FIXED
  void _togglePlayPause() {
    if (_videoController == null || !_isVideoInitialized) {
      return;
    }

    // Prevent auto-hide when tapping controls
    _controlsTimeout?.cancel();

    setState(() {
      if (_isVideoPlaying) {
        _videoController?.pause();
        _isVideoPlaying = false;
        _showControls = true; // Keep controls visible when paused
      } else {
        _videoController?.play();
        _isVideoPlaying = true;
        // Auto-hide controls after delay when playing
        _controlsTimeout?.cancel();
        _controlsTimeout = Timer(const Duration(seconds: 3), () {
          if (mounted && _isVideoPlaying) {
            setState(() => _showControls = false);
          }
        });
      }
    });
  }

  //  Toggle mute/unmute - NEW
  void _toggleMute() {
    if (_videoController == null || !_isVideoInitialized) {
      return;
    }

    // Prevent auto-hide when tapping controls
    _controlsTimeout?.cancel();

    setState(() {
      _isMuted = !_isMuted;
    });

    // Apply volume change
    _videoController?.setVolume(_isMuted ? 0 : 1);

    // Keep controls visible briefly after mute toggle
    setState(() => _showControls = true);
    _controlsTimeout?.cancel();
    _controlsTimeout = Timer(const Duration(seconds: 2), () {
      if (mounted && _isVideoPlaying) {
        setState(() => _showControls = false);
      }
    });
  }

  //  Handle tap on video area (retry or show controls)
  void _handleVideoTap() {
    if (_hasVideoError || !_isVideoInitialized) {
      _retryVideo();
    } else if (_isVideoInitialized) {
      _toggleControls(); // Show/hide controls on tap
    }
  }

  //  Retry video initialization
  void _retryVideo() {
    debugPrint('🔄 Retrying video initialization');
    setState(() {
      _hasVideoError = false;
      _isVideoInitialized = false;
      _showControls = true;
    });
    _videoController?.pause();
    _videoController?.dispose();
    _videoController = null;
    _initializeVideo();
  }
}

///  Helper widget for timer-based callbacks
class TimerWidget extends StatefulWidget {
  final Duration duration;
  final VoidCallback onTimeout;

  const TimerWidget({
    super.key,
    required this.duration,
    required this.onTimeout,
  });

  @override
  State<TimerWidget> createState() => _TimerWidgetState();
}

class _TimerWidgetState extends State<TimerWidget> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer(widget.duration, widget.onTimeout);
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => const SizedBox.shrink();
}
