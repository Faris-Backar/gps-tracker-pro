part of 'db_cubit.dart';

@immutable
abstract class DbState {}

class DbInitial extends DbState {}

class DBFetchLoading extends DbState {}

class DBFetchLoaded extends DbState {
  final LocationModel locationModel;
  DBFetchLoaded({
    required this.locationModel,
  });
}
