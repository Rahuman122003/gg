import 'package:flutter/cupertino.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';

class CallPage extends StatelessWidget {
  const CallPage({Key? key, required this.callID,required this.userName}): super(key: key);
  final String callID;
  final String userName;

  @override
  Widget build(BuildContext context) {
    return ZegoUIKitPrebuiltCall(
        appID:
        int.parse(dotenv.env['APP_ID']!) ,
        appSign:
        dotenv.env['APP_SIGN']!,
        callID: callID,
        userID: userName,
        userName: userName,
        config: ZegoUIKitPrebuiltCallConfig.oneOnOneVideoCall()
    );
  }
}
