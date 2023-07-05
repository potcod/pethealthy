import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class PetFeeding extends StatefulWidget {
  //const PetFeeding({super.key});

  var petID;
  PetFeeding({this.petID});
  final String title = "Feeding Times";

  @override
  State<PetFeeding> createState() => _PetFeedingState();
}

class _PetFeedingState extends State<PetFeeding> {
  TimeOfDay time = TimeOfDay.now();


  void _showTimePicker(){
    showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
    ).then((value) {
      time = value!;

      FirebaseFirestore.instance.collection("pets").doc("${widget.petID}").collection("feedTimes").add(
          {
            "time": time.toString(),
          }
      ).then((value) {
        print("Successfully added feed time");

      }).catchError((error) {
        print("Failed to add feed time");
        print(error);
      });
    });


  }
  var feed = [];

  void _loadData(){
    FirebaseFirestore.instance.collection("pets").doc("${widget.petID}").collection("feedTimes").get()
        .then((QuerySnapshot querySnapshot){
      print("Successfully loaded feeding times");

      querySnapshot.docs.forEach((QueryDocumentSnapshot document) {
        print("FEEDDATA:" + document.toString());
        String temp = document.data().toString();
        String tempStr = temp.substring(temp.indexOf('(') + 1, temp.indexOf(')'));


        feed.add(tempStr);
      });
      setState(() {
      });

    }).catchError((error){
      print("Failed to load feeding times");
      print("Error:" + error);
    });
    print("Feedlength:" + feed.length.toString() );

  }  //loadData
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadData();
  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: ListView.builder(
        itemCount: feed.length,

        itemBuilder: (BuildContext context, int index) {

          return Container(
            child: Center(

                child: Text(
                    feed[index].toString(), style: TextStyle(fontSize: 25),
                ),
            ),
          );

        }),
      floatingActionButton: FloatingActionButton(
        onPressed: _showTimePicker,
        tooltip: 'Add Feeding Time',
        child: const Icon(Icons.add),
      ),




    );
  }
}
