class PixaBayResponse {
  int? total;
  int? totalHits;
  List<Hits>? hits;

  PixaBayResponse({this.total, this.totalHits, this.hits});

  PixaBayResponse.fromJson(Map<String, dynamic> json) {
    total = json['total'];
    totalHits = json['totalHits'];
    if (json['hits'] != null) {
      hits = <Hits>[];
      json['hits'].forEach((v) {
        hits!.add(Hits.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['total'] = total;
    data['totalHits'] = totalHits;
    if (hits != null) {
      data['hits'] = hits!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Hits {
  int? id;
  String? pageURL;
  String? type;
  String? tags;
  String? previewURL;
  String? largeImageURL;
  int? imageSize;
  int? views;
  int? downloads;
  int? collections;
  int? likes;
  int? comments;
  int? userId;
  String? user;
  String? userImageURL;
  bool? isHovering = false;

  Hits(
      {this.id,
      this.pageURL,
      this.type,
      this.tags,
      this.previewURL,
      this.largeImageURL,
      this.imageSize,
      this.views,
      this.downloads,
      this.collections,
      this.likes,
      this.comments,
      this.userId,
      this.user,
      this.userImageURL,
      this.isHovering = false});

  Hits.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    pageURL = json['pageURL'];
    type = json['type'];
    tags = json['tags'];
    previewURL = json['previewURL'];
    largeImageURL = json['largeImageURL'];
    imageSize = json['imageSize'];
    views = json['views'];
    downloads = json['downloads'];
    collections = json['collections'];
    likes = json['likes'];
    comments = json['comments'];
    userId = json['user_id'];
    user = json['user'];
    userImageURL = json['userImageURL'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['pageURL'] = pageURL;
    data['type'] = type;
    data['tags'] = tags;
    data['previewURL'] = previewURL;
    data['largeImageURL'] = largeImageURL;
    data['imageSize'] = imageSize;
    data['views'] = views;
    data['downloads'] = downloads;
    data['collections'] = collections;
    data['likes'] = likes;
    data['comments'] = comments;
    data['user_id'] = userId;
    data['user'] = user;
    data['userImageURL'] = userImageURL;
    return data;
  }
}
