import 'package:covid_tracker/View/world_states.dart';
import 'package:flutter/material.dart';

class DetailScreen extends StatefulWidget {
  const DetailScreen(
      {Key? key,
      required this.image,
      required this.name,
      required this.totalCases,
      required this.totalDeaths,
      required this.totalRecovered,
      required this.active,
      required this.critical,
      required this.todayRecovered,
      required this.test})
      : super(key: key);

  final String image;
  final String name;
  final int totalCases;
  final int totalDeaths;
  final int totalRecovered;
  final int active;
  final int critical;
  final int todayRecovered;
  final int test;

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.name),
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Stack(
              alignment: Alignment.topCenter,
              children: [
                Padding(
                  padding: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height * 0.067),
                  child: Card(
                    child: Column(
                      children: [
                        ReusableRow(
                          title: "Cases",
                          value: widget.totalCases.toString(),
                        ),
                        ReusableRow(
                          title: "Recovered",
                          value: widget.totalRecovered.toString(),
                        ),
                        ReusableRow(
                          title: "Deaths",
                          value: widget.totalDeaths.toString(),
                        ),
                        ReusableRow(
                          title: "Active",
                          value: widget.active.toString(),
                        ),
                        ReusableRow(
                          title: "Critical",
                          value: widget.critical.toString(),
                        ),
                        ReusableRow(
                          title: "Today Recoveres",
                          value: widget.todayRecovered.toString(),
                        ),
                        ReusableRow(
                          title: "Tests",
                          value: widget.test.toString(),
                        ),
                      ],
                    ),
                  ),
                ),
                CircleAvatar(
                  radius: 50,
                  backgroundImage: NetworkImage(widget.image),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
