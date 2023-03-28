import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weather_app/data/response/status.dart';
import 'package:weather_app/res/components/card_widget.dart';
import 'package:weather_app/screen/help_screen.dart';
import 'package:weather_app/view_model/home_view_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  HomeViewModel homeViewModel = HomeViewModel();
  final TextEditingController _locationController = TextEditingController();
  final ValueNotifier<bool> _changeButton = ValueNotifier<bool>(true);

  @override
  void initState() {
    super.initState();
    getLocation();
  }

  @override
  void dispose() {
    super.dispose();
    _locationController.dispose();
  }

  getLocation() async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    final data = sp.getString("name");
    await homeViewModel.fetchWeatherApi(data!);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ChangeNotifierProvider<HomeViewModel>(
        create: (BuildContext context) => homeViewModel,
        child: Consumer<HomeViewModel>(
          builder: (context, value, _) {
            switch (value.weather.status) {
              case Status.LOADING:
                return const Center(child: CircularProgressIndicator());
              case Status.ERROR:
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(value.weather.message.toString()),
                      ValueListenableBuilder(
                        valueListenable: _changeButton,
                        builder: (context, value, child) {
                          return Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 100.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                TextFormField(
                                  controller: _locationController,
                                  decoration: const InputDecoration(
                                    hintText: "Enter Location",
                                    prefixIcon: Icon(Icons.location_on),
                                  ),
                                  onChanged: (val) {
                                    _changeButton.value = val.trim().isEmpty;
                                  },
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                ElevatedButton(
                                    onPressed: () async {
                                      await homeViewModel.fetchWeatherApi(
                                          _locationController.text);
                                      final SharedPreferences sp =
                                          await SharedPreferences.getInstance();
                                      sp.setString('name',
                                          _locationController.text.toString());
                                    },
                                    child: _changeButton.value
                                        ? const Text("Save")
                                        : const Text("Update"))
                              ],
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                );
              case Status.COMPLETED:
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: CardWidget(
                          location: value.weather.data!.location,
                          dateTime: value.weather.data!.lastUpdated,
                          temperature:
                              value.weather.data!.temperatureC.toString(),
                          weatherIcon: value.weather.data!.icon,
                          weatherCondition: value.weather.data!.conditionText,
                        )),
                    const SizedBox(
                      height: 10,
                    ),
                    ValueListenableBuilder(
                      valueListenable: _changeButton,
                      builder: (context, value, child) {
                        return Padding(
                          padding:
                              const EdgeInsets.symmetric(horizontal: 100.0),
                          child: Column(
                            children: [
                              TextFormField(
                                controller: _locationController,
                                decoration: const InputDecoration(
                                  hintText: "Enter Location",
                                  prefixIcon: Icon(Icons.location_on),
                                ),
                                onChanged: (val) {
                                  _changeButton.value = val.trim().isEmpty;
                                },
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              ElevatedButton(
                                  onPressed: () async {
                                    await homeViewModel.fetchWeatherApi(
                                        _locationController.text);
                                    final SharedPreferences sp =
                                        await SharedPreferences.getInstance();
                                    sp.setString('name',
                                        _locationController.text.toString());
                                  },
                                  child: _changeButton.value
                                      ? const Text("Save")
                                      : const Text("Update"))
                            ],
                          ),
                        );
                      },
                    ),
                  ],
                );
              default:
                return Container();
            }
          },
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(8.0),
        child: FloatingActionButton(
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const HelpScreen()));
          },
          child: const Icon(Icons.help),
        ),
      ),
    );
  }
}
