import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cached_pdfview/flutter_cached_pdfview.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:url_launcher/url_launcher.dart';

class PDFBottomSheetSM extends StatefulWidget {
  final String pdfUrl;
  const PDFBottomSheetSM({
    super.key,
    required this.pdfUrl,
  });

  @override
  State<PDFBottomSheetSM> createState() => _PDFBottomSheetSMState();
}

class _PDFBottomSheetSMState extends State<PDFBottomSheetSM> {
  bool isDownloading = false;

  Future<void> openDownloadedPDF(String pdfPath) async {
    final url = pdfPath;
    try {
      await launchUrl(
        Uri.parse(url),
        mode: LaunchMode.externalApplication,
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          backgroundColor: Colors.red, content: Text('Gagal Membuka Berkas ')));
      throw "Tidak dapat membuka file $e";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      height: MediaQuery.of(context).size.height * 0.8,
      child: LoadingOverlay(
        isLoading: isDownloading,
        color: Colors.grey,
        progressIndicator: SpinKitWaveSpinner(
          size: 70,
          color: Colors.blueAccent,
          waveColor: Colors.blueAccent,
          trackColor: Colors.grey,
        ),
        child: Column(
          children: [
            AppBar(
              title: Text('PDF Viewer'),
              centerTitle: true,
              leading: IconButton(
                  onPressed: () async {
                    // await downloadPDF(widget.pdfUrl);
                    await openDownloadedPDF(widget.pdfUrl);
                  },
                  icon: Icon(Icons.download_outlined)),
              actions: [
                IconButton(
                  icon: Icon(Icons.close),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
            Expanded(
              child: PDF(
                nightMode: false,
                enableSwipe: true,
                fitEachPage: true,
                preventLinkNavigation: false,
              ).cachedFromUrl(
                widget.pdfUrl,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PDFBottomSheetSK extends StatefulWidget {
  final String pdfUrl;
  const PDFBottomSheetSK({
    super.key,
    required this.pdfUrl,
  });

  @override
  State<PDFBottomSheetSK> createState() => _PDFBottomSheetSKState();
}

class _PDFBottomSheetSKState extends State<PDFBottomSheetSK> {
  bool isDownloading = false;

  Future<void> openDownloadedPDF(String pdfPath) async {
    final url = pdfPath;
    try {
      await launchUrl(
        Uri.parse(url),
        mode: LaunchMode.externalApplication,
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          backgroundColor: Colors.red, content: Text('Gagal Membuka Berkas ')));
      throw "Tidak dapat membuka file $e";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      height: MediaQuery.of(context).size.height * 0.8,
      child: LoadingOverlay(
        isLoading: isDownloading,
        color: Colors.grey,
        progressIndicator: SpinKitWaveSpinner(
          size: 70,
          color: Colors.blueAccent,
          waveColor: Colors.blueAccent,
          trackColor: Colors.grey,
        ),
        child: Column(
          children: [
            AppBar(
              title: Text('PDF Viewer'),
              centerTitle: true,
              leading: IconButton(
                  onPressed: () async {
                    // await downloadPDF(widget.pdfUrl);
                    await openDownloadedPDF(widget.pdfUrl);
                  },
                  icon: Icon(Icons.download_outlined)),
              actions: [
                IconButton(
                  icon: Icon(Icons.close),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
            Expanded(
              child: PDF(
                nightMode: false,
                enableSwipe: true,
                fitEachPage: true,
                preventLinkNavigation: false,
              ).cachedFromUrl(
                widget.pdfUrl,
              ),
            ),
          ],
        ),
      ),
    );
  }
}