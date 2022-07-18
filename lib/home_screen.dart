import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gps_tracker_pro/bloc/cubit/db_cubit.dart';
import 'package:gps_tracker_pro/model/location_model.dart';
import 'package:gps_tracker_pro/widgets/text_input_form_field_widget.dart';
import 'package:gps_tracker_pro/widgets/web_view.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final latController = TextEditingController();
  final longController = TextEditingController();
  @override
  void initState() {
    super.initState();
    BlocProvider.of<DbCubit>(context).fetchLocation();
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text('GPS Tracker'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: BlocBuilder<DbCubit, DbState>(
            builder: (context, state) {
              if (state is DBFetchLoading) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              if (state is DBFetchLoaded) {
                LocationModel locationModel = state.locationModel;
                latController.text = locationModel.lat.toString();
                longController.text = locationModel.lng.toString();
                print('location=>$locationModel');
                return Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: TextInputFormFieldWidget(
                            isEnabled: false,
                            inputController: latController,
                            textInputType: TextInputType.text,
                            hintText: '',
                            validatorFunction: (String? value) {
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Expanded(
                          flex: 2,
                          child: TextInputFormFieldWidget(
                            isEnabled: false,
                            inputController: longController,
                            textInputType: TextInputType.text,
                            hintText: '',
                            validatorFunction: (String? value) {
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Card(
                      elevation: 5.0,
                      child: SizedBox(
                        height: screenSize.height * 0.6,
                        child: WebViewWidget(
                            title: 'Map',
                            url:
                                'https://www.google.com/maps/search/?api=1&query=${latController.text},${longController.text},'),
                      ),
                    ),
                  ],
                );
              }
              return Container();
            },
          ),
        ),
      ),
    );
  }
}
