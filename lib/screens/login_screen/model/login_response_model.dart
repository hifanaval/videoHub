// To parse this JSON data, do
//
//     final loginResponseModel = loginResponseModelFromJson(jsonString);

import 'dart:convert';

LoginResponseModel loginResponseModelFromJson(String str) => LoginResponseModel.fromJson(json.decode(str));

String loginResponseModelToJson(LoginResponseModel data) => json.encode(data.toJson());

class LoginResponseModel {
    bool? status;
    bool? privilage;
    Token? token;
    String? phone;

    LoginResponseModel({
        this.status,
        this.privilage,
        this.token,
        this.phone,
    });

    factory LoginResponseModel.fromJson(Map<String, dynamic> json) => LoginResponseModel(
        status: json["status"],
        privilage: json["privilage"],
        token: json["token"] == null ? null : Token.fromJson(json["token"]),
        phone: json["phone"],
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "privilage": privilage,
        "token": token?.toJson(),
        "phone": phone,
    };
}

class Token {
    String? refresh;
    String? access;

    Token({
        this.refresh,
        this.access,
    });

    factory Token.fromJson(Map<String, dynamic> json) => Token(
        refresh: json["refresh"],
        access: json["access"],
    );

    Map<String, dynamic> toJson() => {
        "refresh": refresh,
        "access": access,
    };
}
