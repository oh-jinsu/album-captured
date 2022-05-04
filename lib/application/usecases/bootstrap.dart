import 'package:album/application/controller.dart';
import 'package:album/core/action.dart';
import 'package:album/core/usecase.dart';

class BootstrapUseCase extends UseCase {
  @override
  void onAwake() {
    of<App>().on<Created>((action) {});
  }
}
