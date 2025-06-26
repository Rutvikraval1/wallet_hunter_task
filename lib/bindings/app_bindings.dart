import 'package:get/get.dart';
import '../controllers/auth_controller.dart';
import '../controllers/family_controller.dart';
import '../controllers/family_tree_controller.dart';

class AppBindings extends Bindings {
  @override
  void dependencies() {
    // Initialize controllers
    Get.put<AuthController>(AuthController(), permanent: true);
    Get.put<FamilyController>(FamilyController(), permanent: true);
    Get.lazyPut<FamilyTreeController>(() => FamilyTreeController());
  }
}
