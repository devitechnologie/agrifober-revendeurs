import 'package:equatable/equatable.dart';
// local imports
import 'package:agrifober_resellers/features/auth/domain/entities/index.dart';

/// The revendeur's own information as Agrifober recorded it.
class Profile extends Equatable {
  final String uid;
  final String fullName;
  final PhoneNumber phone;
  final String region;
  final String locationUrl;

  const Profile({
    required this.uid,
    required this.fullName,
    required this.phone,
    required this.region,
    required this.locationUrl,
  });

  @override
  List<Object?> get props => [uid, fullName, phone, region, locationUrl];
}
