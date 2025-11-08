import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/state_manager.dart';

class DashboardController extends GetxController {
  RxInt selectedChatId = 0.obs;

  void selectChat(int id) {
    selectedChatId.value = id;
  }
}
