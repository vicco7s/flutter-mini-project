
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kec_app/model/UserService/suratbatalservice.dart';

class ControllerSuratBatal {
  
  final CollectionReference _suratBatal =
      FirebaseFirestore.instance.collection('users');

  void createInputPegawai(SuratBatal suratBatal) async {
    final json = suratBatal.toJson();
    var querySnapshot =
        await _suratBatal.orderBy("id", descending: true).limit(1).get();
    var maxId =
        querySnapshot.docs.isNotEmpty ? querySnapshot.docs.first.get("id") : 0;
    json["id"] = maxId + 1;
    await _suratBatal.add(json);
  }

}