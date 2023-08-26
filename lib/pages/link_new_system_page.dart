// import 'package:casher_mobile_app/tools/connect_to_system/add_new_system.dart';
// import 'package:flutter/material.dart';

// class LinkNewSystemPage extends StatefulWidget {
//   const LinkNewSystemPage({super.key});

//   @override
//   State<LinkNewSystemPage> createState() => _LinkNewSystemPageState();
// }

// class _LinkNewSystemPageState extends State<LinkNewSystemPage> {
//   bool _isLoading = false;
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Link a new system'),
//       ),
//       body: Center(
//           child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: <Widget>[
//           ElevatedButton(
//               onPressed: () async {
//                 _isLoading = true;
//                 setState(() {});
//                 final result =
//                     await AddNewSystem.instance.linkNewSystem(context);
//                 ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//                   content: Text(result),
//                 ));
//                 _isLoading = false;
//               },
//               child: const Text('Link a new system')),
//           if (_isLoading)
//             const Padding(
//               padding: EdgeInsets.all(16),
//               child: CircularProgressIndicator(),
//             ),
//         ],
//       )),
//     );
//   }
// }
