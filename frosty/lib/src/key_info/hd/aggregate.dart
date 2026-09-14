import 'dart:typed_data';

import 'package:coinlib/coinlib.dart' as cl;
import 'package:frosty/src/key_info/aggregate.dart';

import 'derivable.dart';
import 'hd_key_info.dart';

class HDAggregateKeyInfo extends AggregateKeyInfo implements HDDerivableInfo {
  @override
  final HDKeyInfo hdInfo;

  new({
    required super.group,
    required super.publicShares,
    required this.hdInfo,
  });

  new master({required super.group, required super.publicShares})
    : hdInfo = HDKeyInfo.master;

  new masterFromInfo(AggregateKeyInfo info)
    : this.master(group: info.group, publicShares: info.publicShares);

  new fromReader(super.reader)
    : hdInfo = HDKeyInfo.fromReader(reader),
      super.fromReader();

  /// Convenience constructor to construct from serialised [bytes].
  new fromBytes(Uint8List bytes) : this.fromReader(cl.BytesReader(bytes));

  /// Convenience constructor to construct from encoded [hex].
  new fromHex(String hex) : this.fromBytes(cl.hexToBytes(hex));

  @override
  void write(cl.Writer writer) {
    hdInfo.write(writer);
    super.write(writer);
  }

  @override
  HDAggregateKeyInfo derive(int index) {
    final (tweak, newHdInfo) = hdInfo.deriveTweakAndInfo(groupKey, index);
    return HDAggregateKeyInfo(
      group: group.tweak(tweak)!,
      publicShares: publicShares.tweak(tweak)!,
      hdInfo: newHdInfo,
    );
  }
}
