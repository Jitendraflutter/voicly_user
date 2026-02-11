import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:voicly/model/caller_model.dart';

class HomeController extends GetxController {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Observable list of callers
  RxList<CallerModel> callers = <CallerModel>[].obs;
  RxBool isGridView = true.obs;

  @override
  void onInit() {
    super.onInit();
    callers.bindStream(
      _db
          .collection('callers')
          .where('isActive', isEqualTo: true) // Only show active callers
          .snapshots()
          .map(
            (snapshot) => snapshot.docs
                .map((doc) => CallerModel.fromFirestore(doc))
                .toList(),
          ),
    );
  }

  void toggleView() => isGridView.value = !isGridView.value;
}
