import 'package:freezed_annotation/freezed_annotation.dart';

part 'failures.freezed.dart';

/// Failures are used in the DOMAIN layer.
/// Repositories catch Exceptions and return Failures.
/// UI layer receives Failures and shows user-friendly messages.
///
/// Exception (data layer) → Failure (domain layer) → UI message (presentation)
@freezed
sealed class Failure with _$Failure {
  /// No internet connection
  const factory Failure.network({required String message}) = NetworkFailure;

  /// Server returned an error
  const factory Failure.server({required String message}) = ServerFailure;

  /// Local storage operation failed
  const factory Failure.cache({required String message}) = CacheFailure;

  /// Authentication failed
  const factory Failure.auth({required String message}) = AuthFailure;

  /// Something unexpected happened
  const factory Failure.unexpected({required String message}) =
      UnexpectedFailure;
}
