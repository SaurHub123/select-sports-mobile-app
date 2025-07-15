import 'package:select_sports/core/models/user_model.dart';

class BookingDetail {
  final String id;
  final String status;
  final dynamic cancellationFee;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String slotId;
  final String userId;
  final String transactionId;
  final Slot slot;
  final Transaction transaction;
  final Team team;

  BookingDetail({
    required this.id,
    required this.status,
    this.cancellationFee,
    required this.createdAt,
    required this.updatedAt,
    required this.slotId,
    required this.userId,
    required this.transactionId,
    required this.slot,
    required this.transaction,
    required this.team,
  });

  factory BookingDetail.fromJson(Map<String, dynamic> json) => BookingDetail(
        id: json["id"],
        status: json["status"],
        cancellationFee: json["cancellationFee"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        slotId: json["slotId"],
        userId: json["userId"],
        transactionId: json["transactionId"],
        slot: Slot.fromJson(json["slot"]),
        transaction: Transaction.fromJson(json["transaction"]),
        team: Team.fromJson(json["team"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "status": status,
        "cancellationFee": cancellationFee,
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
        "slotId": slotId,
        "userId": userId,
        "transactionId": transactionId,
        "slot": slot.toJson(),
        "transaction": transaction.toJson(),
        "team": team.toJson(),
      };
}

class Slot {
  final String id;
  final DateTime startTime;
  final DateTime endTime;
  final int maxPlayer;
  final String slotType;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int price;
  final int discountedPrice;
  final String sportId;
  final String venueId;
  final String team1Id;
  final String team2Id;
  final dynamic hostId;
  final Venue venue;
  final Sport sport;

  Slot({
    required this.id,
    required this.startTime,
    required this.endTime,
    required this.maxPlayer,
    required this.slotType,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.price,
    required this.discountedPrice,
    required this.sportId,
    required this.venueId,
    required this.team1Id,
    required this.team2Id,
    this.hostId,
    required this.venue,
    required this.sport,
  });

  factory Slot.fromJson(Map<String, dynamic> json) => Slot(
        id: json["id"],
        startTime: DateTime.parse(json["startTime"]),
        endTime: DateTime.parse(json["endTime"]),
        maxPlayer: json["maxPlayer"],
        slotType: json["slotType"],
        status: json["status"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        price: json["price"],
        discountedPrice: json["discountedPrice"],
        sportId: json["sportId"],
        venueId: json["venueId"],
        team1Id: json["team1Id"],
        team2Id: json["team2Id"],
        hostId: json["hostId"],
        venue: Venue.fromJson(json["venue"]),
        sport: Sport.fromJson(json["sport"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "startTime": startTime.toIso8601String(),
        "endTime": endTime.toIso8601String(),
        "maxPlayer": maxPlayer,
        "slotType": slotType,
        "status": status,
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
        "price": price,
        "discountedPrice": discountedPrice,
        "sportId": sportId,
        "venueId": venueId,
        "team1Id": team1Id,
        "team2Id": team2Id,
        "hostId": hostId,
        "venue": venue.toJson(),
        "sport": sport.toJson(),
      };
}

class Venue {
  final String id;
  final String name;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<String> images;
  final String description;
  final String locationUrl;
  final List<String> amenities;
  final String addressId;
  final Address address;
  final List<Sport> sports;

  Venue({
    required this.id,
    required this.name,
    required this.createdAt,
    required this.updatedAt,
    required this.images,
    required this.description,
    required this.locationUrl,
    required this.amenities,
    required this.addressId,
    required this.address,
    required this.sports,
  });

  factory Venue.fromJson(Map<String, dynamic> json) => Venue(
        id: json["id"],
        name: json["name"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        images: List<String>.from(json["images"].map((x) => x)),
        description: json["description"],
        locationUrl: json["locationUrl"],
        amenities: List<String>.from(json["amenities"].map((x) => x)),
        addressId: json["addressId"],
        address: Address.fromJson(json["address"]),
        sports: List<Sport>.from(json["sports"].map((x) => Sport.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
        "images": List<dynamic>.from(images.map((x) => x)),
        "description": description,
        "locationUrl": locationUrl,
        "amenities": List<dynamic>.from(amenities.map((x) => x)),
        "addressId": addressId,
        "address": address.toJson(),
        "sports": List<dynamic>.from(sports.map((x) => x.toJson())),
      };
}

class Address {
  final String id;
  final String street;
  final String city;
  final String state;
  final String postalCode;
  final String country;
  final dynamic nearby;
  final DateTime createdAt;
  final DateTime updatedAt;

  Address({
    required this.id,
    required this.street,
    required this.city,
    required this.state,
    required this.postalCode,
    required this.country,
    this.nearby,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Address.fromJson(Map<String, dynamic> json) => Address(
        id: json["id"],
        street: json["street"],
        city: json["city"],
        state: json["state"],
        postalCode: json["postalCode"],
        country: json["country"],
        nearby: json["nearby"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "street": street,
        "city": city,
        "state": state,
        "postalCode": postalCode,
        "country": country,
        "nearby": nearby,
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
      };
}

class Sport {
  final String id;
  final String name;
  final List<String> rules;
  final int totalPlayer;
  final DateTime createdAt;
  final DateTime updatedAt;

  Sport({
    required this.id,
    required this.name,
    required this.rules,
    required this.totalPlayer,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Sport.fromJson(Map<String, dynamic> json) => Sport(
        id: json["id"],
        name: json["name"],
        rules: List<String>.from(json["rules"].map((x) => x)),
        totalPlayer: json["totalPlayer"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "rules": List<dynamic>.from(rules.map((x) => x)),
        "totalPlayer": totalPlayer,
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
      };
}

class Transaction {
  final String id;
  final String userId;
  final String method;
  final int amount;
  final String currency;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;
  final Razorpay? razorpay;

  Transaction({
    required this.id,
    required this.userId,
    required this.method,
    required this.amount,
    required this.currency,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    this.razorpay,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) => Transaction(
        id: json["id"],
        userId: json["userId"],
        method: json["method"],
        amount: json["amount"],
        currency: json["currency"],
        status: json["status"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        razorpay: json["razorpay"] != null ? Razorpay.fromJson(json["razorpay"]) : null,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "userId": userId,
        "method": method,
        "amount": amount,
        "currency": currency,
        "status": status,
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
        "razorpay": razorpay?.toJson(),
      };
}

class Razorpay {
  final String id;
  final String orderId;
  final String paymentId;
  final String signature;

  Razorpay({
    required this.id,
    required this.orderId,
    required this.paymentId,
    required this.signature,
  });

  factory Razorpay.fromJson(Map<String, dynamic> json) => Razorpay(
        id: json["id"],
        orderId: json["razorpayOrderId"],
        paymentId: json["razorpayPaymentId"],
        signature: json["razorpaySignature"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "orderId": orderId,
        "paymentId": paymentId,
        "signature": signature,
      };
}

class Team {
  final String id;
  final String name;
  final String color;
  final String status;
  final List<User> teamMembers;
  final DateTime createdAt;
  final DateTime updatedAt;

  Team({
    required this.id,
    required this.name,
    required this.color,
    required this.status,
    required this.teamMembers,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Team.fromJson(Map<String, dynamic> json) => Team(
        id: json["id"],
        name: json["name"],
        color: json["color"],
        status: json["status"],
        teamMembers: (json['users'] as List<dynamic>?)
                ?.map((user) => User.fromJson(user))
                .toList() ??
            [],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "color": color,
        "status": status,
        "teamMembers": List<dynamic>.from(teamMembers.map((x) => x)),
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
      };
}
