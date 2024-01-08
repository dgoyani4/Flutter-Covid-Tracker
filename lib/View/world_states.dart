import 'package:flutter/material.dart';

import 'package:covid_tracker/Model/world_states.dart';
import 'package:covid_tracker/Services/states_services.dart';
import 'package:covid_tracker/View/countries_list.dart';

import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:pie_chart/pie_chart.dart';

class WorldStatesScreen extends StatefulWidget {
  const WorldStatesScreen({Key? key}) : super(key: key);

  @override
  State<WorldStatesScreen> createState() => _WorldStatesScreenState();
}

class _WorldStatesScreenState extends State<WorldStatesScreen>
    with TickerProviderStateMixin {
  late final AnimationController _animationController =
      AnimationController(vsync: this, duration: const Duration(seconds: 3))
        ..repeat();

  @override
  void dispose() {
    super.dispose();
    _animationController.dispose();
  }

  final colorList = <Color>[
    const Color(0xff4285f4),
    const Color(0xff1aa260),
    const Color(0xffde5246),
  ];

  @override
  Widget build(BuildContext context) {
    StatesServices statesServices = StatesServices();

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            children: [
              SizedBox(height: MediaQuery.of(context).size.height * .01),
              FutureBuilder<WorldStatesModel>(
                future: statesServices.fetchWorldStatesRecords(),
                builder: (context, AsyncSnapshot<WorldStatesModel> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Expanded(
                      flex: 1,
                      child: SpinKitFadingCircle(
                        color: Colors.white,
                        size: 50.0,
                        controller: _animationController,
                      ),
                    );
                  } else if (snapshot.hasError) {
                    return const Text('Error fetching data');
                  } else if (!snapshot.hasData || snapshot.data == null) {
                    return const Text('No data available');
                  } else {
                    final data = snapshot.data!;

                    return Column(
                      children: [
                        PieChart(
                          dataMap: {
                            "Total": double.parse(data.cases.toString()),
                            "Recovered":
                                double.parse(data.recovered.toString()),
                            "Death": double.parse(data.deaths.toString()),
                          },
                          chartValuesOptions: const ChartValuesOptions(
                              showChartValuesInPercentage: true),
                          chartRadius: MediaQuery.of(context).size.width / 3.2,
                          legendOptions: const LegendOptions(
                              legendPosition: LegendPosition.left),
                          animationDuration: const Duration(microseconds: 1200),
                          chartType: ChartType.ring,
                          colorList: colorList,
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              vertical:
                                  MediaQuery.of(context).size.height * 0.06),
                          child: Card(
                            child: Column(
                              children: [
                                ReusableRow(
                                    title: "Total",
                                    value: data.cases.toString()),
                                ReusableRow(
                                    title: "Deaths",
                                    value: data.deaths.toString()),
                                ReusableRow(
                                    title: "Recovered",
                                    value: data.recovered.toString()),
                                ReusableRow(
                                    title: "Active",
                                    value: data.active.toString()),
                                ReusableRow(
                                    title: "Critical",
                                    value: data.critical.toString()),
                                ReusableRow(
                                    title: "Today Deaths",
                                    value: data.todayDeaths.toString()),
                                ReusableRow(
                                    title: "Today Recovered",
                                    value: data.todayRecovered.toString()),
                              ],
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) =>
                                    const CountriesListScreen(),
                              ),
                            );
                          },
                          child: Container(
                            height: MediaQuery.of(context).size.height * .06,
                            decoration: BoxDecoration(
                              color: const Color(0xff1aa260),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Center(
                              child: Text("Track Countries"),
                            ),
                          ),
                        ),
                      ],
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ReusableRow extends StatelessWidget {
  const ReusableRow({Key? key, required this.title, required this.value})
      : super(key: key);

  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 10, 10, 5),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title),
              Text(value),
            ],
          ),
          const SizedBox(height: 5),
          const Divider(),
        ],
      ),
    );
  }
}
