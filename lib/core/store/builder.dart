import 'package:album/core/store/store.dart';
import 'package:flutter/cupertino.dart';

class StoreBuilder<T> extends StatelessWidget {
  final Store<T> store;

  final Widget Function(T data) onNext;

  final Widget Function()? onLoad;

  final Widget Function()? onError;

  const StoreBuilder(
    this.store, {
    Key? key,
    required this.onNext,
    this.onLoad,
    this.onError,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: store.stream,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return onError?.call() ?? Container();
        }

        if (snapshot.hasData) {
          final data = snapshot.data as StoreData<T>;

          return onNext(data.x);
        }

        return onLoad?.call() ??
            const Center(child: CupertinoActivityIndicator());
      },
    );
  }
}
