import 'dart:collection';

import 'package:flutter/widgets.dart';

final Queue<BuildContext> contextQueue = Queue();

BuildContext requireContext() => contextQueue.last;
