import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';
import 'package:table_calendar/table_calendar.dart';
class WeightData{
  final double x;
  final double y;
  WeightData({required this.x, required this.y});
}
List<WeightData> get weightDataForList{
  final wdata = <double>[];

  Future<void> _getWeightData() async {
     await FirebaseFirestore.instance.collection("pets").doc("GWOt6I3jMBKqCkXTGe1v").collection("weightData").get()
         .then((querySnapshot){
       print("Successfully loaded weightData collection");
       querySnapshot.docs.forEach((element) {

         wdata.add(element.data()['weight']);
         print("Document data:" + element.data()['weight'].toString());
       });

     }).catchError((error){
       print("Failed to load weight graph data");
       print("Error:" + error);
     });
  } //getWeightData


  _getWeightData();

  print("LENGTH OF WDATA:" + wdata.length.toString());

   return wdata
      .mapIndexed(
          (index, element) => WeightData(x: index.toDouble(), y: element))
      .toList();

}

