library;

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:frosty/frosty.dart' as frosty;
export 'package:frosty/frosty.dart' hide loadFrosty;

const _defaultWebRoot = 'assets/packages/frosty_flutter/web/pkg/frosty_rust';

/// Loads the underlying Rust library, including web assets when needed.
Future<void> loadFrosty({String? webRoot}) {
  final effectiveWebRoot = kIsWeb ? (webRoot ?? _defaultWebRoot) : null;
  return frosty.loadFrosty(webRoot: effectiveWebRoot);
}

/// A widget that ensures the frosty library is loaded before use.
class const FrostyLoader({
  super.key,

  /// The widget to show whilst frosty is loading.
  required final Widget loadChild,

  /// The builder for a library load error.
  required final Widget Function(BuildContext context, Object? error)
  errorBuilder,

  /// The builder called once the library has loaded.
  required final WidgetBuilder builder,
}) extends StatefulWidget {
  @override
  State<FrostyLoader> createState() => _FrostyLoaderState();
}

class _FrostyLoaderState extends State<FrostyLoader> {
  late Future<void> loadResult;

  @override
  void initState() {
    super.initState();
    loadResult = loadFrosty();
  }

  @override
  Widget build(BuildContext context) => FutureBuilder<void>(
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.done) {
        if (snapshot.hasError) {
          return widget.errorBuilder(context, snapshot.error);
        }
        return widget.builder(context);
      }

      return widget.loadChild;
    },
    future: loadResult,
  );
}
