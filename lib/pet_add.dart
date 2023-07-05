import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:pet_healthy_proj/pet_profile.dart';
import 'firebase_options.dart';
import 'package:firebase_database/firebase_database.dart';
class PetAdd extends StatefulWidget {
  const PetAdd({super.key});

  @override
  State<PetAdd> createState() => _PetAddState();
}

class _PetAddState extends State<PetAdd> {
  TextEditingController nameController = TextEditingController();
  TextEditingController majorController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(



      body: Center(
        child: Column(
          children: [
            TextField(
              controller: nameController,
              obscureText: false,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Name',

              ),
            ),
            TextField(
              controller: majorController,
              obscureText: false,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Major',

              ),
            ),
            ElevatedButton(
              onPressed: (){
                FirebaseFirestore.instance.collection("pets").add(
                    {
                      "name": nameController.text,
                      "image" : majorController.text,
                    }
                ).then((DocumentReference doc){
                  print("Successfully added pet");

                }).catchError((error){
                  print("Failed to add pet");
                  print(error);

                });
              },
              child: Text('Add Pet'),
            ),


          ],

        ),



      ),






    );
  }
}
