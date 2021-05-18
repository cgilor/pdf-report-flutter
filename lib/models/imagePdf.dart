final String tableImages = 'images';

class ImageFields {
  static final List<String> values = [id, path, description, time];

  static final String id = '_id';
  static final String path = 'path';
  static final String description = 'description';
  static final String time = 'time';
}

class ImagePdf {
  final int? id;
  final String path;
  final String description;
  final DateTime createdTime;

  const ImagePdf({
    this.id,
    required this.path,
    required this.description,
    required this.createdTime,
  });

  ImagePdf copy({
    int? id,
    String? path,
    String? description,
    DateTime? createdTime,
  }) =>
      ImagePdf(
        id: id ?? this.id,
        path: path ?? this.path,
        description: description ?? this.description,
        createdTime: createdTime ?? this.createdTime,
      );

  static ImagePdf fromJson(Map<String, Object?> json) => ImagePdf(
        id: json[ImageFields.id] as int?,
        path: json[ImageFields.path] as String,
        description: json[ImageFields.description] as String,
        createdTime: DateTime.parse(json[ImageFields.time] as String),
      );
  Map<String, Object?> toJson() => {
        ImageFields.id: id,
        ImageFields.path: path,
        ImageFields.description: description,
        ImageFields.time: createdTime.toIso8601String(),
      };
}
