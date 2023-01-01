import 'package:get/get.dart';


import '../../layout/layout_controller.dart';

class Binding extends Bindings {
  @override
  void dependencies() {
    //NOTE:  implement dependencies

    Get.lazyPut<SocialLayoutController>(() => SocialLayoutController());
  }
}
