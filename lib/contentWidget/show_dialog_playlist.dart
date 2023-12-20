import 'package:flutter/material.dart';
import 'package:music_player_project_one/hive_db/db_functions.dart';
import 'package:music_player_project_one/modal_class/songList.dart';
import 'package:music_player_project_one/utils/controllers.dart';

import '../hive_db/db_playlist.dart';
import '../hive_db/db_playlist_names.dart';
import '../modal_class/playlistnames.dart';

class ShowDialogAdd extends StatefulWidget {
  final ModalClassAllSongs playListNameModal;
  final int songId;
   const ShowDialogAdd(  {super.key, required this.playListNameModal, required this.songId});

  @override
  State<ShowDialogAdd> createState() => _ShowDialogState();
}

class _ShowDialogState extends State<ShowDialogAdd> {
  late ModalClassAllSongs playListNameModal;
  late int songId;
  final playListNameController=TextEditingController();
  bool isfirstVisible=true;
  bool issecondVisible=false;
  PlayerControllers playerControllers=PlayerControllers();
  List<String> playNames=[];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    playListNameModal=widget.playListNameModal;
    songId=widget.songId;
  }
  @override
  Widget build(BuildContext context) {
    try {
      getPlayNAMES();
    }on  Exception catch  (e){
      print(e);
    }
    return Dialog(
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      backgroundColor: Colors.blueGrey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Visibility(
            visible: isfirstVisible,
              child: firstSection(),),
          Visibility(
              visible: issecondVisible,
              child: secondSection(),),
        ],
      ),
    );
  }

  Widget firstSection() {
    return Column(children: [
      const SizedBox(height: 10,),
      const Text("Select From the Playlist",style: TextStyle(fontSize: 20,color: Colors.white),),
      SizedBox(
          height:MediaQuery.of(context).size.height * 0.4,
          child: ValueListenableBuilder(
            valueListenable: playListNamesNotifier,
            builder: (BuildContext context, List<PlayListName> value, Widget? child) {

              return Padding(
                padding: const EdgeInsets.all(10.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: ListView.separated(
                    padding: const EdgeInsets.only(left: 5.0,right: 5.0,top: 10.0,bottom: 10.0),
                    itemBuilder: (context,index){
                      var itemData=value[index];
                  //    print("firstSection BuilderValue $playNames");
                      playNames.clear();
                      playNames=value.map((e) => e.namess).toList();
                        return GestureDetector(
                          onTap: (){
                            playListNameModal.playListName=playNames[index];
                            playListNameModal.playListStatus='yes';
                            addToPlaylist(playListNameModal,songId);
                            setState(() {

                            });
                          },
                            child: Text(itemData.namess,style: const TextStyle(fontSize: 19,color: Colors.blueGrey),));
                      },
                    separatorBuilder: (context,index){
                      return const Divider();
                    },
                    itemCount: value.length,
                  ),
                ),
              );
            },
          )),
      ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
        ),
          onPressed: (){
        setState(() {
          isfirstVisible=false;
          issecondVisible=true;
        });
      }, child: const Text("Create Playlist",style: TextStyle(color: Colors.blueGrey),)),
    ],);
  }

  Widget secondSection() {
    return
      Column(children: [
       Container(
           padding: const EdgeInsets.all(10.0),
           decoration: BoxDecoration(
           borderRadius: BorderRadius.circular(10.0),
         ),
           child: Container(
             decoration: BoxDecoration(
               borderRadius: BorderRadius.circular(10.0),
               color: Colors.white,
             ),
             child: TextField(
               maxLength: 10,
               controller: playListNameController,
               decoration: const InputDecoration(
                 hintText: "Enter Playlist Name",
                 contentPadding: EdgeInsets.all(5.0),
                 border: InputBorder.none,
               ),
             ),
           )),
      ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
        ),
          onPressed: (){
        checkName(context);
      }, child: const Text("Create",style: TextStyle(color: Colors.blueGrey),)),
      const SizedBox(height: 10,),
    ],);
  }

  void checkName(BuildContext context) {
    String names=playListNameController.text;
    print("playNames.asMap()     $names   ${playNames.contains(names)}");
    if(names.isEmpty){
      playerControllers.scaffoldMessage(context, "Enter Valid Name");
    }else if(playNames.contains(names)){
      print("CONTAINS ${playNames.contains(names)}");
      playerControllers.scaffoldMessage(context,"Playlist have the same name");
    }else{
      PlayListName val=PlayListName(namess: names);
      addPLaylistNAmes(val);
      setState(() {
        isfirstVisible=true;
        issecondVisible=false;
      });
    }
  }
}
