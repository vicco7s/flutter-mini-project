
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:kec_app/model/UserService/suratbatalservice.dart';

class ControllerSuratBatal {
  

  void createInputSuratBatal(SuratBatal suratBatal) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final userId = user.uid;
      
      final CollectionReference userCollection =
          FirebaseFirestore.instance.collection('users');

      final CollectionReference suratBatalCollection =
          userCollection.doc(userId).collection('suratbatal');

      final json = suratBatal.toJson();
      
      var querySnapshot =
          await suratBatalCollection.orderBy("id", descending: true).limit(1).get();
      var maxId =
          querySnapshot.docs.isNotEmpty ? querySnapshot.docs.first.get("id") : 0;
      json["id"] = maxId + 1;
      
      await suratBatalCollection.add(json);
    }
  }

}