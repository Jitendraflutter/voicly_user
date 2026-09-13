import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class DeleteAccountController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Observable variables
  var reasons = <String>[].obs;
  var infoText = "".obs;
  var title = "Delete Account".obs;
  var isLoading = true.obs;
  var selectedReason = RxnString();
  var isConfirmEnabled = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchDeleteReasons();
  }

  void fetchDeleteReasons() async {
    try {
      isLoading(true);
      DocumentSnapshot doc = await _firestore
          .collection("general_information")
          .doc("user") // Based on your Firestore screenshot
          .collection("account_delete_reasons")
          .doc("data")
          .get();

      if (doc.exists) {
        var data = doc.data() as Map<String, dynamic>;
        infoText.value = data['info'] ?? "";
        title.value = data['title'] ?? "Delete Account";
        reasons.assignAll(List<String>.from(data['reasons'] ?? []));
      }
    } catch (e) {
      Get.snackbar("Error", "Failed to load deletion info");
    } finally {
      isLoading(false);
    }
  }
}