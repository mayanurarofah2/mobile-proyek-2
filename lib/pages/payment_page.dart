import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PaymentPage extends StatefulWidget {
  final String snapToken;

  PaymentPage({required this.snapToken});

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  late final WebViewController controller;

  @override
  void initState() {
    super.initState();

    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted) // 🔥 WAJIB
      ..setBackgroundColor(Colors.white)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            print("Loading: $progress%");
          },
          onPageStarted: (String url) {
            print("START: $url");
          },
          onPageFinished: (String url) {
            print("FINISH: $url");
          },
          onWebResourceError: (error) {
            print("ERROR WEBVIEW: $error");
          },
        ),
      )
      ..loadRequest(
        Uri.parse(
          "https://app.sandbox.midtrans.com/snap/v2/vtweb/${widget.snapToken}",
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Pembayaran")),
      body: WebViewWidget(controller: controller),
    );
  }
}