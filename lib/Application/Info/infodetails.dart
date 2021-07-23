import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class InfoDetailsScreen extends StatelessWidget {
  InfoDetailsScreen(this.title, this.url);
  final String title;
  final String url;
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
            iconTheme: IconThemeData(
              color: Color(0xff06224A), 
            ),
        backgroundColor: Colors.white,
        title: Text(title, style: TextStyle(
                  color: Color(0xff06224A),
                  fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),

      body: WebView(initialUrl: url,),
    );
  }
}
