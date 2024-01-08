import 'package:covid_tracker/Services/states_services.dart';
import 'package:covid_tracker/View/detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class CountriesListScreen extends StatefulWidget {
  const CountriesListScreen({Key? key}) : super(key: key);

  @override
  State<CountriesListScreen> createState() => _CountriesListScreenState();
}

class _CountriesListScreenState extends State<CountriesListScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _searchController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    StatesServices statesServices = StatesServices();

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: TextFormField(
          controller: _searchController,
          decoration: InputDecoration(
            hintText: "Search with country name...",
            contentPadding: const EdgeInsets.symmetric(horizontal: 20),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(50.0),
            ),
          ),
          onChanged: (value) {
            setState(() {});
          },
        ),
      ),
      body: SafeArea(
        child: FutureBuilder(
          future: statesServices.countriesListApi(),
          builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Shimmer.fromColors(
                baseColor: Colors.grey.shade700,
                highlightColor: Colors.grey.shade100,
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: 12,
                  itemBuilder: (context, index) {
                    return ListTile(
                      leading:
                          Container(height: 50, width: 50, color: Colors.white),
                      title:
                          Container(height: 10, width: 80, color: Colors.white),
                      subtitle:
                          Container(height: 10, width: 80, color: Colors.white),
                    );
                  },
                ),
              );
            } else if (snapshot.hasError) {
              return const Text('Error fetching data');
            } else if (!snapshot.hasData || snapshot.data == null) {
              return const Text('No data available');
            } else {
              final data = snapshot.data!;

              return ListView.builder(
                shrinkWrap: true,
                itemCount: data.length,
                itemBuilder: (context, index) {
                  String name = data[index]["country"];

                  if (_searchController.text.isEmpty) {
                    return InkWell(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => DetailScreen(
                              image: data[index]["countryInfo"]["flag"],
                              name: data[index]["country"],
                              totalCases: data[index]["cases"],
                              totalDeaths: data[index]["deaths"],
                              totalRecovered: data[index]["recovered"],
                              active: data[index]["active"],
                              critical: data[index]["critical"],
                              todayRecovered: data[index]["todayRecovered"],
                              test: data[index]["tests"],
                            ),
                          ),
                        );
                      },
                      child: ListTile(
                        leading: Image(
                          image:
                              NetworkImage(data[index]["countryInfo"]["flag"]),
                          height: 50,
                          width: 50,
                        ),
                        title: Text(data[index]["country"]),
                        subtitle: Text(data[index]["cases"].toString()),
                      ),
                    );
                  } else if (name
                      .toLowerCase()
                      .contains(_searchController.text.toLowerCase())) {
                    return InkWell(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => DetailScreen(
                              image: data[index]["countryInfo"]["flag"],
                              name: data[index]["country"],
                              totalCases: data[index]["cases"],
                              totalDeaths: data[index]["deaths"],
                              totalRecovered: data[index]["recovered"],
                              active: data[index]["active"],
                              critical: data[index]["critical"],
                              todayRecovered: data[index]["todayRecovered"],
                              test: data[index]["tests"],
                            ),
                          ),
                        );
                      },
                      child: ListTile(
                        leading: Image(
                          image:
                              NetworkImage(data[index]["countryInfo"]["flag"]),
                          height: 50,
                          width: 50,
                        ),
                        title: Text(data[index]["country"]),
                        subtitle: Text(data[index]["cases"].toString()),
                      ),
                    );
                  } else {
                    return Container();
                  }
                },
              );
            }
          },
        ),
      ),
    );
  }
}
