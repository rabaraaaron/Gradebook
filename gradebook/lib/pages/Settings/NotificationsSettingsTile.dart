import 'package:flutter/material.dart';

// class NotificationsSettingsTile extends StatefulWidget {
//
//   @override
//   Widget build(BuildContext context) {
//     TextStyle textStyle_H5 = Theme.of(context).textTheme.headline5;
//
//
//     return Container(
//       child: SwitchListTile(
//         title: const Text('Lights'),
//         //value: ans,
//         onChanged: (bool value) {
//           // setState(() {
//           //   ans = value;
//           // });
//         },
//         secondary: const Icon(Icons.lightbulb_outline),
//       ),
//       //SwitchListTile(
//         //secondary: Icon(Icons.notification_important_sharp),
//         //title: Text('Allow Notifications',
//
//         //  style: textStyle_H5,
//         //),
//       //),
//     );
//   }
// }

class NotificationsSettingsTile extends StatefulWidget {
  @override
  _NotificationsSettingsTileState createState() => _NotificationsSettingsTileState();
}

class _NotificationsSettingsTileState extends State<NotificationsSettingsTile> {
  bool _allowNotifications = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 20),
      child: Column(
        children: [
          SwitchListTile(
            title: const Text('Allow Notifications'),
            value: _allowNotifications,
            onChanged: (bool value) {
              setState(() {
                _allowNotifications = value;
              });
            },
            //secondary: const Icon(Icons.lightbulb_outline),
          ),
          SwitchListTile(
            title: const Text('Allow Notifications'),
            value: _allowNotifications,
            onChanged: (bool value) {
              setState(() {
                _allowNotifications = value;
              });
            },
            //secondary: const Icon(Icons.lightbulb_outline),
          ),
        ],
      ),
    );
  }
}

