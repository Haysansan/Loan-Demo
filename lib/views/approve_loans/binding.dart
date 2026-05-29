import 'package:get/get.dart';
import 'package:apploan/views/views.dart';

class ApproveLoansBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ApproveLoansController>(() => ApproveLoansController());
  }
}
