import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:pet_healthy_proj/pet_create.dart';
import 'package:pet_healthy_proj/pet_profile.dart';
import 'firebase_options.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override

  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(

        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Pet Healthy'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
var petList =[];
var petID = [];

void _goCreateProfile(){
  Navigator.of(context).push(
    MaterialPageRoute(
      builder: (context) => PetCreate(),
    ),
  );
}

final petRef = FirebaseFirestore.instance.collection("pets").doc();
void getData(){
  FirebaseFirestore.instance.collection("pets").get()
      .then((QuerySnapshot querySnapshot){
    print("Successfully loaded pets");

    querySnapshot.docs.forEach((QueryDocumentSnapshot document) {
      DocumentReference doc = document.reference;

      petList.add(document.data());
      petID.add(doc.id);

    });
    setState(() {
    });

  }).catchError((error){
    print("Failed to load pets");
    print("Error:" + error);
  });

} // getData
@override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }
  static const IconData pets = IconData(0xe4a1, fontFamily: 'MaterialIcons');

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      floatingActionButton: FloatingActionButton(
        onPressed: _goCreateProfile,
        tooltip: 'Add Profile',
        child: const Icon(Icons.add),
      ),

      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),

      body: ListView.builder(

          itemCount: petList.length,
          itemBuilder: (BuildContext context, int index) {

            return Container(
              margin: EdgeInsets.only(top: 5,bottom: 5, left: 4, right: 4),
              child: ListTile(
                shape: RoundedRectangleBorder(
                    side: BorderSide(width: 2),
                    borderRadius: BorderRadius.circular(50)
                ),

                onTap: (){
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => PetProfile(petDetails:petList[index], petID: petID[index]))
                  );
                },
                title: Container(
                  margin: EdgeInsets.only(top: 5, bottom: 5),
                  height: 50,

                  child: Row(
                    children: [
                      Container(
                        margin: EdgeInsets.only(right: 20),
                        child: CircleAvatar(
                          backgroundImage: NetworkImage('${petList[index]['image']}'),
                        ),
                      ),



                      Column(
                        children: [
                          Text('${petList[index]['name']}',
                            style: TextStyle(
                              fontSize: 25,
                            ),

                          ),
                        ],
                      ),
                      Spacer(),
                      Icon(
                        Icons.pets,
                      ),



                    ],
                  ),
                ),

              ),
            );

          }),



    );
  }
}
