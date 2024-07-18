/// width : 23.17
/// height : 14.43
/// depth : 28.01

class Dimensions {
  Dimensions({
      this.width, 
      this.height, 
      this.depth,});

  Dimensions.fromJson(dynamic json) {
    width = (json['width'] is int) ? (json['width'] as int).toDouble() : json['width']?.toDouble();
    height = (json['height'] is int) ? (json['height'] as int).toDouble() : json['height']?.toDouble();
    depth = (json['depth'] is int) ? (json['depth'] as int).toDouble() : json['depth']?.toDouble();
  }
  double? width;
  double? height;
  double? depth;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['width'] = width;
    map['height'] = height;
    map['depth'] = depth;
    return map;
  }

}