import 'dart:convert';
import 'dart:developer';
import 'package:bloc/bloc.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:gps_tracker_pro/model/location_model.dart';
import 'package:http/http.dart' as http;
import 'package:meta/meta.dart';

part 'db_state.dart';

class DbCubit extends Cubit<DbState> {
  DbCubit() : super(DbInitial());

  final databaseReference = FirebaseDatabase.instance.ref();

  fetchLocation() async {
    emit(DbInitial());
    emit(DBFetchLoading());

    var url = "https://bustracker-497d8-default-rtdb.firebaseio.com/GPS.json";
    try {
      final response = await http.get(Uri.parse(url));
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      if (extractedData.isEmpty) {
        return;
      }
      final res = LocationModel.fromMap(extractedData);
      print(res);
      emit(DBFetchLoaded(locationModel: res));
    } catch (error) {
      log(error.toString());
    }
  }
}
