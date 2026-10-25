import 'package:freezed_annotation/freezed_annotation.dart';
// local imports
import 'package:agrifober_resellers/features/auth/domain/entities/index.dart';
import 'package:agrifober_resellers/features/profile/domain/entities/index.dart';

part 'profile_model.freezed.dart';
part 'profile_model.g.dart';

@freezed
abstract class ProfileModel with _$ProfileModel {
  const factory ProfileModel({
    required String id,
    @JsonKey(name: 'full_name') @Default('') String fullName,
    @JsonKey(name: 'country_code') @Default('+212') String countryCode,
    @Default('') String phone,
    @Default('') String region,
    @JsonKey(name: 'location_url') @Default('') String locationUrl,
  }) = _ProfileModel;

  factory ProfileModel.fromJson(Map<String, dynamic> json) =>
      _$ProfileModelFromJson(json);
}

extension ProfileModelX on ProfileModel {
  Profile toEntity() => Profile(
    uid: id,
    fullName: fullName,
    phone: PhoneNumber(
      countryCode: countryCode.isEmpty ? '+212' : countryCode,
      number: phone,
    ),
    region: region,
    locationUrl: locationUrl,
  );
}
