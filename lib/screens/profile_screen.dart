import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';

import '../utils/colors.dart';

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
      backgroundColor: appThemeT,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Expanded(
                  flex:1,
                  child: Text("")),
              Expanded(
                flex: 1,
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
                      const SizedBox(height: 50,),
                      Text(name!,style: const TextStyle(fontSize: 20),),
                      const SizedBox(height: 20,),
                      Text(phno!,style: const TextStyle(fontSize: 20),)
                    ],
                  ),
                ),
              ),
              const Expanded(
                flex: 1,
                child:  Align(
                  alignment: Alignment.bottomCenter,
                  child: Column(
                    children: [
                      Expanded(child: Text("")),
                      Expanded(child: Text("")),
                      Expanded(child: Column(children: [
                        Text("About",style: TextStyle(color: Colors.white),),
                        Text("Terms & Conditions",style: TextStyle(color: Colors.white),),
                        Text("Version 0.1",style: TextStyle(color: Colors.white),)
                      ],))
                  ],),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
