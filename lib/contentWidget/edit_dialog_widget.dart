import 'package:flutter/material.dart';
import 'package:music_player_project_one/modal_class/songList.dart';
import 'package:music_player_project_one/utils/controllers.dart';

import '../hive_db/db_functions.dart';

class ShowEditDialog extends StatefulWidget {
  ModalClassAllSongs modal;
  int indexSong;
   ShowEditDialog( {super.key, required this.modal,required  this.indexSong});

  @override
  State<ShowEditDialog> createState() => _ShowEditDialogState();
}

class _ShowEditDialogState extends State<ShowEditDialog> {
  late ModalClassAllSongs modal;
  final editController=TextEditingController();
  PlayerControllers playerControllers=PlayerControllers();
  late int indexSong;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    modal=widget.modal;
    indexSong=widget.indexSong;
    editController.text=modal.display_name;
  }
  @override
  Widget build(BuildContext context) {
    return Dialog(
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text("Enter the new name...",style: TextStyle(fontSize: 20),),
            const SizedBox(height: 10,),
            Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.blueGrey,
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(5.0),
              ),
              child: TextField(
                controller: editController,
              ),
            ),
            Align(
              alignment: AlignmentDirectional.center,
                child: ElevatedButton(onPressed: (){
                  var editedName=editController.text;
                  if(editedName.isNotEmpty) {
                    modal.display_name = editedName;
                    editNode(modal,indexSong);

                  }else{
                    playerControllers.scaffoldMessage(context, "Value cant be empty");
                  }
                }, child: const Text("Save")))
          ],
        ),
      ),
    );
  }
}
