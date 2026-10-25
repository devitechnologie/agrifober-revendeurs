import 'package:equatable/equatable.dart';

/// The signed-in revendeur.
class User extends Equatable {
  final String uid;
  final String fullName;
  final PhoneNumber phone;
  final String region;
  final String locationUrl;
  final AuthTokens tokens;

  const User({
    required this.uid,
    required this.fullName,
    required this.phone,
    required this.region,
    required this.locationUrl,
    required this.tokens,
  });

  User copyWith({AuthTokens? tokens}) => User(
    uid: uid,
    fullName: fullName,
    phone: phone,
    region: region,
    locationUrl: locationUrl,
    tokens: tokens ?? this.tokens,
  );

  @override
  List<Object?> get props => [
    uid,
    fullName,
    phone,
    region,
    locationUrl,
    tokens,
  ];
}

class AuthTokens extends Equatable {
  final String accessToken;
  final String refreshToken;

  const AuthTokens({required this.accessToken, required this.refreshToken});

  @override
  List<Object?> get props => [accessToken, refreshToken];
}

class PhoneNumber extends Equatable {
  final String countryCode; // ex: +212
  final String number; // ex: 634029817

  const PhoneNumber({required this.countryCode, required this.number});

  /// `+212 634029817`
  String get display => number.isEmpty ? '' : '$countryCode $number';

  @override
  List<Object?> get props => [countryCode, number];
}
