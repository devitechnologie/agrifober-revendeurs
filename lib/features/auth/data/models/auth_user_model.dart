import 'package:freezed_annotation/freezed_annotation.dart';
// local imports
import 'package:agrifober_resellers/features/auth/domain/domain.dart';

part 'auth_user_model.freezed.dart';
part 'auth_user_model.g.dart';

/// `{ data: profile, meta: tokens }` — returned by login, refresh and password
/// change, and stored as is in local storage (see AuthLocalService).
@freezed
abstract class AuthUserModel with _$AuthUserModel {
  const factory AuthUserModel({
    required AuthUserDataModel data,
    required AuthMetaModel meta,
  }) = _AuthUserModel;

  factory AuthUserModel.fromJson(Map<String, dynamic> json) =>
      _$AuthUserModelFromJson(json);
}

@freezed
abstract class AuthUserDataModel with _$AuthUserDataModel {
  const factory AuthUserDataModel({
    required String id,
    @JsonKey(name: 'full_name') @Default('') String fullName,
    @JsonKey(name: 'country_code') @Default('+212') String countryCode,
    @Default('') String phone,
    @Default('') String region,
    @JsonKey(name: 'location_url') @Default('') String locationUrl,
  }) = _AuthUserDataModel;

  factory AuthUserDataModel.fromJson(Map<String, dynamic> json) =>
      _$AuthUserDataModelFromJson(json);
}

@freezed
abstract class AuthMetaModel with _$AuthMetaModel {
  const factory AuthMetaModel({
    required String token,
    @JsonKey(name: 'refresh_token') required String refreshToken,
    @JsonKey(name: 'token_type') @Default('Bearer') String tokenType,
    @JsonKey(name: 'expires_in') @Default(0) int expiresIn,
  }) = _AuthMetaModel;

  factory AuthMetaModel.fromJson(Map<String, dynamic> json) =>
      _$AuthMetaModelFromJson(json);
}

// Mapping extensions
extension AuthUserModelX on AuthUserModel {
  User toEntity() {
    return User(
      uid: data.id,
      fullName: data.fullName,
      phone: PhoneNumber(
        countryCode: data.countryCode.isEmpty ? '+212' : data.countryCode,
        number: data.phone,
      ),
      region: data.region,
      locationUrl: data.locationUrl,
      tokens: AuthTokens(
        accessToken: meta.token,
        refreshToken: meta.refreshToken,
      ),
    );
  }
}

extension UserToModelX on User {
  AuthUserModel toModel() {
    return AuthUserModel(
      data: AuthUserDataModel(
        id: uid,
        fullName: fullName,
        countryCode: phone.countryCode,
        phone: phone.number,
        region: region,
        locationUrl: locationUrl,
      ),
      meta: AuthMetaModel(
        token: tokens.accessToken,
        refreshToken: tokens.refreshToken,
      ),
    );
  }
}
