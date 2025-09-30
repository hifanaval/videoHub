// To parse this JSON data, do
//
//     final homeDataModel = homeDataModelFromJson(jsonString);

import 'dart:convert';

HomeDataModel homeDataModelFromJson(String str) => HomeDataModel.fromJson(json.decode(str));

String homeDataModelToJson(HomeDataModel data) => json.encode(data.toJson());

class HomeDataModel {
    Map<String, dynamic>? user;
    List<dynamic>? banners;
    List<CategoryDict>? categoryDict;
    List<HomeItem>? results;
    bool? status;
    bool? next;

    HomeDataModel({
        this.user,
        this.banners,
        this.categoryDict,
        this.results,
        this.status,
        this.next,
    });

    factory HomeDataModel.fromJson(Map<String, dynamic> json) => HomeDataModel(
        user: json["user"] == null ? null : Map<String, dynamic>.from(json["user"]),
        banners: json["banners"] == null ? [] : List<dynamic>.from(json["banners"]),
        categoryDict: json["category_dict"] == null ? [] : List<CategoryDict>.from(json["category_dict"]!.map((x) => CategoryDict.fromJson(x))),
        results: json["results"] == null ? [] : List<HomeItem>.from(json["results"]!.map((x) => HomeItem.fromJson(x))),
        status: json["status"],
        next: json["next"],
    );

    Map<String, dynamic> toJson() => {
        "user": user == null ? null : Map<String, dynamic>.from(user!),
        "banners": banners == null ? [] : List<dynamic>.from(banners!),
        "category_dict": categoryDict == null ? [] : List<dynamic>.from(categoryDict!.map((x) => x.toJson())),
        "results": results == null ? [] : List<dynamic>.from(results!.map((x) => x.toJson())),
        "status": status,
        "next": next,
    };
}

class CategoryDict {
    String? id;
    String? title;

    CategoryDict({
        this.id,
        this.title,
    });

    factory CategoryDict.fromJson(Map<String, dynamic> json) => CategoryDict(
        id: json["id"],
        title: json["title"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
    };
}

class HomeItem {
    int? id;
    String? description;
    String? image;
    String? video;
    List<int>? likes;
    List<dynamic>? dislikes;
    List<dynamic>? bookmarks;
    List<int>? hide;
    DateTime? createdAt;
    bool? follow;
    User? user;

    HomeItem({
        this.id,
        this.description,
        this.image,
        this.video,
        this.likes,
        this.dislikes,
        this.bookmarks,
        this.hide,
        this.createdAt,
        this.follow,
        this.user,
    });

    factory HomeItem.fromJson(Map<String, dynamic> json) => HomeItem(
        id: json["id"],
        description: json["description"],
        image: json["image"],
        video: json["video"],
        likes: json["likes"] == null ? [] : List<int>.from(json["likes"]),
        dislikes: json["dislikes"] == null ? [] : List<dynamic>.from(json["dislikes"]),
        bookmarks: json["bookmarks"] == null ? [] : List<dynamic>.from(json["bookmarks"]),
        hide: json["hide"] == null ? [] : List<int>.from(json["hide"]),
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        follow: json["follow"],
        user: json["user"] == null ? null : User.fromJson(json["user"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "description": description,
        "image": image,
        "video": video,
        "likes": likes == null ? [] : List<dynamic>.from(likes!),
        "dislikes": dislikes == null ? [] : List<dynamic>.from(dislikes!),
        "bookmarks": bookmarks == null ? [] : List<dynamic>.from(bookmarks!),
        "hide": hide == null ? [] : List<dynamic>.from(hide!),
        "created_at": createdAt?.toIso8601String(),
        "follow": follow,
        "user": user?.toJson(),
    };
}

class User {
    int? id;
    String? name;
    dynamic image;

    User({
        this.id,
        this.name,
        this.image,
    });

    factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"],
        name: json["name"],
        image: json["image"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "image": image,
    };
}
