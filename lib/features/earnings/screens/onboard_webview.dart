import 'package:drop_n_fresh/shared/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:webview_flutter/webview_flutter.dart';

class OnboardWebview extends StatefulWidget {
  final String checkoutUrl;
  final String? checkoutSessionId;
  final String? bagOrderId;

  const OnboardWebview({
    super.key,
    required this.checkoutUrl,
    this.checkoutSessionId,
    this.bagOrderId,
  });

  @override
  State<OnboardWebview> createState() => _OnboardWebviewState();
}

class _OnboardWebviewState extends State<OnboardWebview> {
  late final WebViewController _controller;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();

    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            debugPrint('WebView loading: $progress%');
          },
          onPageStarted: (String url) {
            setState(() {
              _isLoading = true;
            });
          },
          onPageFinished: (String url) {
            setState(() => _isLoading = false);
            _handleUrlNavigation(url);
          },
          onWebResourceError: (WebResourceError error) {
            debugPrint('WebView error: ${error.description}');
          },
          onUrlChange: (UrlChange change) {
            if (change.url != null) {
              _handleUrlNavigation(change.url!);
            }
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.checkoutUrl));
  }

  void _handleUrlNavigation(String url) {
    if (!url.startsWith("https://connect.stripe.com")) {
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Onboard',
        titleAlignment: TitleAlignment.left,
        showBackBtn: false,
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () {
              context.pop();
              context.pop();
            },
          ),
        ],
      ),
      body: Stack(
        children: <Widget>[
          WebViewWidget(controller: _controller),

          if (_isLoading)
            Container(
              color: Colors.white.withValues(alpha: 0.9),
              child: const Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    CircularProgressIndicator(),
                    SizedBox(height: 16),
                    Text('Loading onboarding...'),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
