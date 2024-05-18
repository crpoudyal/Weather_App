import 'package:flutter/material.dart';

class CardWidget extends StatelessWidget {
  final String location;
  final String dateTime;
  final String temperature;
  final String weatherIcon;
  final String weatherCondition;
  const CardWidget(
      {Key? key,
      required this.location,
      required this.dateTime,
      required this.temperature,
      required this.weatherIcon,
      required this.weatherCondition})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        children: [
          Text(
            location.toString().toUpperCase(),
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          Text(
            dateTime.toString(),
            style: const TextStyle(
              fontSize: 16,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                children: [
                  Text(
                    '${temperature.toString()}°C',
                    style: const TextStyle(
                        fontSize: 50, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
              Column(
                children: [
                  Image.network('https:$weatherIcon'),
                  Text(
                    weatherCondition.toString().toUpperCase(),
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ],
          )
        ],
      ),
    );
  }
}
