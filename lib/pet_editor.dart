import 'dart:io';


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'main.dart';

class PetEdit extends StatefulWidget {
  String get title => 'Edit Profile';
  // const PetEdit({super.key});
  var petID;
  PetEdit({this.petID});
  @override
  State<PetEdit> createState() => _PetEditState();
}

class _PetEditState extends State<PetEdit> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _ageController = TextEditingController();
  TextEditingController _goalController = TextEditingController();

  File? image;
  Future _getFromGallery() async {
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (image == null) return;

    final imageTemp = File(image.path);
    setState(() => this.image = imageTemp);
    print("Image=" + image.toString());

    File temp = File(image.path);
    print("Temp =" + temp.toString());


    uploadToFBS(temp);

  }
  _getFromCamera() async {
    final image = await ImagePicker().pickImage(source: ImageSource.camera);
    if (image == null) return;

    final imageTemp = File(image.path);
    setState(() => this.image = imageTemp);
    print("Image=" + image.toString());

    File temp = File(image.path);
    print("Temp =" + temp.toString());


    uploadToFBS(temp);

  }
  var finImg;

  void uploadToFBS(File file){
    var fileName = DateTime.now().millisecondsSinceEpoch.toString() + "jpg";
    FirebaseStorage.instance.ref().child("cs4750/" + fileName).putFile(file)
        .then((res){
      print("Successfully uploaded photo");
      res.ref.getDownloadURL().then((value){
        print("VALUE:" + value);
        finImg = value;
      }).catchError((error){
        print("Failed to get download url");
      });
    }).catchError((error){
      print("Failed to upload photo");
    });

  } //uploadToFBS
  void _showNoToast(BuildContext context) {
    final scaffold = ScaffoldMessenger.of(context);
    scaffold.showSnackBar(
      SnackBar(
        content: const Text('Nothing Entered!'),

      ),
    );
  }
  void _showYesToast(BuildContext context) {
    final scaffold = ScaffoldMessenger.of(context);
    scaffold.showSnackBar(
      SnackBar(
        content: const Text('Pet Successfully Updated!'),

      ),
    );
  }
  bool entered = false;
  void _editor(){
    print("EDITOR HAS BEEN CALLED");
    // if(finImg.text.isNotEmpty) {
    //   FirebaseFirestore.instance.collection("pets").doc(widget.petID).update(
    //       {
    //         'image': finImg,
    //       }).catchError((error){
    //         print("Failed to image update");
    //         print("Error:" + error);
    //       });
    //
    //   entered = true;
    // }
    if(_nameController.text.isNotEmpty){
      FirebaseFirestore.instance.collection("pets").doc(widget.petID).update(
          {
            'name': _nameController.text,
          }).catchError((error){
        print("Failed to name update");
        print("Error:" + error);
      });
      entered = true;
    }
    if(_ageController.text.isNotEmpty){
      FirebaseFirestore.instance.collection("pets").doc(widget.petID).update(
          {
            'age': double.parse(_ageController.text),
          }
      );
      entered = true;
    }
    if(_goalController.text.isNotEmpty){
      FirebaseFirestore.instance.collection("pets").doc(widget.petID).update(
          {
            'goal': double.parse(_goalController.text),
          }
      );
      entered = true;
    }
    if(entered==true)
      _showYesToast(context);

    else(
        _showNoToast(context)
    );

  }
  void _goMain(){
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => MyHomePage(title: '',),
      ),
    );
  }
  void alertButton(){
  Widget noButton = TextButton(
    child: Text("No"),
    onPressed: () {
      Navigator.of(context, rootNavigator: true).pop('alert');
    },
  );
  Widget yesButton = TextButton(
    child: Text("Yes"),
    onPressed: (){
      FirebaseFirestore.instance.collection("pets").doc(widget.petID).delete();
      _goMain();

    },

  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text("Alert"),
    content: Text("Are you sure you want to delete this pet?"),
    actions: [noButton, yesButton,
    ],
  );

  // show the dialog
  showDialog(
  context: context,
  builder: (BuildContext context) {
  return alert;
  },
  );
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),

      body: Column(
        children: [

          Expanded(
            child: ElevatedButton(
              onPressed: (){
                showModalBottomSheet(
                    context: context,
                    builder: (context) {
                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          ListTile(
                            leading: new Icon(Icons.photo),
                            title: new Text('Photo'),
                            onTap: () {
                              _getFromGallery();
                              Navigator.pop(context);
                            },
                          ),
                          ListTile(
                            leading: new Icon(Icons.camera_alt_outlined),
                            title: new Text('Camera'),
                            onTap: () {
                              _getFromCamera();
                              Navigator.pop(context);
                            },
                          ),

                        ],
                      );

                    });

              },
              child: Text("Pick an Image"),
            ),
          ),

          Expanded(
            child: TextField(
              controller: _nameController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText:'Name',
                prefixText: '',

              ),
            ),
          ),

          Expanded(
            child: TextField(
              controller: _ageController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText:'Age',
                prefixText: '',

              ),
            ),
          ),
          Expanded(
            child: TextField(
              controller: _goalController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText:'Goal',
                prefixText: '',

              ),
            ),
          ),
          ElevatedButton(
            onPressed: (){
              _editor();

            },
            child: Text("Update!"),
          ),
          ElevatedButton(
            onPressed: (){
              alertButton();
            },

            child: Text("Delete"),
          )



        ],
      ),


    );
  }
}
