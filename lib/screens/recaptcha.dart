// import 'package:flutter/material.dart';
// import 'package:webview_flutter_plus/webview_flutter_plus.dart';

// class Recaptcha extends StatefulWidget {
//   const Recaptcha({Key? key}) : super(key: key);

//   @override
//   _RecaptchaState createState() => _RecaptchaState();
// }

// class _RecaptchaState extends State<Recaptcha> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: WebViewPlus(
//         javascriptMode: JavascriptMode.unrestricted,
//         onWebViewCreated: (controller) {
//           controller.loadUrl('lib/assets/webpage/index.html');
//         },
//         javascriptChannels: Set.from([
//           JavascriptChannel(
//             name: 'Captcha',
//             onMessageReceived: (JavascriptMessage message) {},
//           ),
//         ]),
//       ),
//     );
//   }
// }


// // Widget build(BuildContext context) {
// //     return Scaffold(
// //       body: WebViewPlus(
// //         javascriptMode: JavascriptMode.unrestricted,
// //         onWebViewCreated: (controller){
// //           controller.loadUrl("lib/assets/webpage/index.html");
// //         },
// //         javascriptChannels: Set.from([
// //           JavascriptChannel(name: 'Captcha', onMessageReceived: (JavascriptMessage message){
// //             // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => WelcomePage()));
// //           })
// //         ]),
// //       )
// //     );
// //   }