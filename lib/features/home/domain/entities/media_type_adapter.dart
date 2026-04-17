import 'package:hive/hive.dart';
import 'post_entity.dart';

class MediaTypeAdapter extends TypeAdapter<MediaType> {
  @override
  final int typeId = 99;

  @override
  MediaType read(BinaryReader reader) {
    return MediaType.values[reader.readInt()];
  }

  @override
  void write(BinaryWriter writer, MediaType obj) {
    writer.writeInt(obj.index);
  }
}