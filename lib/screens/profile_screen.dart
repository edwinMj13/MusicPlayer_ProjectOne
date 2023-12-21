import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late Box boxSignup;
  String? name,phno;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    boxSignup = Hive.box("signup");
    name=boxSignup.get("userName");
    phno=boxSignup.get("phoneNumber");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey,
      body: SafeArea(
        child: Center(
          child: Container(
            height: 300,
            width: 300,
            decoration: BoxDecoration(
              color: Colors.white,
                  borderRadius: BorderRadius.circular(10.0),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 50,
                  child: Image.asset("assets/panda.png"),
                ),
                SizedBox(height: 50,),
                Text(name!,style: TextStyle(fontSize: 20),),
                SizedBox(height: 20,),
                Text(phno!,style: TextStyle(fontSize: 20),)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
