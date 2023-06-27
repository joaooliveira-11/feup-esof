import 'package:flutter/material.dart';
import 'package:porto_explorer/screens/details_screen.dart';
import 'package:porto_explorer/screens/map_screen.dart';
import 'package:porto_explorer/screens/profile_screen.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:location/location.dart' as loc;
import '../reusable_widgets/navBar.dart';
import 'package:porto_explorer/screens/appLocalizations.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final PageController pageController = PageController();
  final TextEditingController searchController = TextEditingController();
  int selectedIndex = 0;
  loc.LocationData? currentLocation;
  Future<void> getCurrentLocation() async {
    loc.Location location = loc.Location();
    loc.LocationData locationData = await location.getLocation();
    currentLocation = locationData;
  }

  PlacesDetailsResponse? detailFinal;
  Future<PlacesDetailsResponse> fetchDetails(String placeId) async {
    final PlacesDetailsResponse detailsResponse = await GoogleMapsPlaces(
      apiKey: 'AIzaSyDI3VdZjuu7hxVvPlA2XaU78Px8BepEdyQ',
    ).getDetailsByPlaceId(placeId);
    detailFinal = detailsResponse;
    return detailsResponse;
  }

  String getImage(Photo photoReference) {
    const baseUrl =
        "https://maps.googleapis.com/maps/api/place/photo?maxwidth=400";
    String s = photoReference.photoReference;
    final url =
        "$baseUrl&photoreference=$s&key=AIzaSyDI3VdZjuu7hxVvPlA2XaU78Px8BepEdyQ";
    return url;
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations appLocalizations = AppLocalizations.of(context)!;
    return KeyedSubtree(
      key: const Key('homeScreenKey'),
      child: Scaffold(
        body: FutureBuilder(
          future: getCurrentLocation(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (selectedIndex == 0)
                    Padding(
                      padding: const EdgeInsets.all(30.0),
                      child: Text(
                        appLocalizations.translate("travel") ?? "Travel through Porto!",
                        style: const TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  if (selectedIndex == 0)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: TextField(
                        controller: searchController,
                        decoration: InputDecoration(
                          hintText: 'Search',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: BorderSide.none,
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          prefixIcon: const Icon(Icons.search),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: const BorderSide(
                              color: Color(0xFF008080),
                              width: 2,
                            ),
                          ),
                        ),
                      ),
                    ),
                  Expanded(
                    child: PageView(
                      controller: pageController,
                      physics: const NeverScrollableScrollPhysics(),
                      children: [
                        if (selectedIndex == 0)
                          Center(
                            child: ListView(
                              physics: const BouncingScrollPhysics(),
                              padding: const EdgeInsets.only(top: 14, bottom: 14),
                              children: [
                                const SizedBox(height: 10),
                                Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(left: 14),
                                      child: Text(
                                        appLocalizations.translate("nearby") ??
                                            "Nearby you:",
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleLarge,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                nearby(context),
                                const SizedBox(height: 10),
                                Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(left: 14),
                                      child: Text(
                                        appLocalizations.translate("recommended") ?? "recommended:",
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleLarge,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                nearbyRanking(context),
                              ],
                            ),
                          ),
                        if (selectedIndex == 2)
                          const ProfileScreen(),
                        if (selectedIndex == 1)
                          const MapScreen(),
                      ],
                    ),
                  ),
                ],
              );
            }
          },
        ),
        backgroundColor: const Color(0xFFD9D9D9),
        bottomNavigationBar: CustomNavBar(
          selectedIndex: selectedIndex,
          onTabChange: (index) {
            setState(() {
              selectedIndex = index;
            });
            pageController.jumpToPage(index);
          },
          pageController: pageController,
        ),
      ),
    );
  }


  Widget nearby(BuildContext context) {
    String listChecker(List<Photo> lst) {
      if (lst.isNotEmpty) {
        return getImage(lst[0]);
      } else {
        return "https://upload.wikimedia.org/wikipedia/commons/d/d1/Image_not_available.png";
      }
    }

    return SizedBox(
      key: const Key("nearbyWidget"),
      width: MediaQuery.of(context).size.width,
      height: 235,
      child: FutureBuilder(
        future:
        GoogleMapsPlaces(apiKey: 'AIzaSyDI3VdZjuu7hxVvPlA2XaU78Px8BepEdyQ')
            .searchNearbyWithRadius(
            Location(
                lat: currentLocation!.latitude!,
                lng: currentLocation!.longitude!),
            500),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          final PlacesSearchResponse details = snapshot.data!;

          return ListView.separated(
            key: const Key("detailsListView"),
            physics: const BouncingScrollPhysics(),
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              final String placeId = details.results[index].placeId;
              fetchDetails(placeId);
              return SizedBox(
                width: 220,
                child: GestureDetector(
                  onTap: () async {
                    PlacesDetailsResponse detail = await fetchDetails(placeId);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DetailsScreen(
                          details: detail,
                        ),
                      ),
                    );
                  },
                  child: Card(
                    elevation: 0.4,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(12),
                      ),
                    ),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(12),
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Container(
                                child: Image.network(
                                  listChecker(
                                    details.results[index].photos,
                                  ),
                                  width: double.maxFinite,
                                  fit: BoxFit.cover,
                                  height: 150,
                                ),
                              ),
                            ),
                            const SizedBox(height: 5),
                            Row(
                              children: [
                                Flexible(
                                  child: Text(
                                    details.results[index].name,
                                    style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                    softWrap: false,
                                  ),
                                ),
                                const Spacer(),
                                Icon(
                                  Icons.star,
                                  color: Colors.yellow.shade700,
                                  size: 14,
                                ),
                                Text(
                                  details.results[index].rating.toString(),
                                  style: const TextStyle(
                                    fontSize: 12,
                                  ),
                                )
                              ],
                            ),
                            const SizedBox(height: 5),
                            Row(
                              children: [
                                const Icon(
                                  Icons.location_city,
                                  color: Color(0xFF008080),
                                  size: 16,
                                ),
                                const SizedBox(width: 5),
                                Text(
                                  details.results[index].types[0],
                                  style: const TextStyle(
                                    fontSize: 12,
                                  ),
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
            separatorBuilder: (context, index) => const Padding(
              padding: EdgeInsets.only(right: 10),
            ),
            itemCount: details.results.length,
          );
        },
      ),
    );
  }

  //nearby mas com recomendação de ranking >=4
  Widget nearbyRanking(BuildContext context) {
    String listChecker(List<Photo> lst) {
      if (lst.isNotEmpty) {
        return getImage(lst[0]);
      } else {
        return "https://upload.wikimedia.org/wikipedia/commons/d/d1/Image_not_available.png";
      }
    }

    return SizedBox(
      key: const Key("recommendedWidget"),
      width: MediaQuery.of(context).size.width,
      height: 235,
      child: FutureBuilder(
        future: GoogleMapsPlaces(
          apiKey: 'AIzaSyDI3VdZjuu7hxVvPlA2XaU78Px8BepEdyQ',
        ).searchNearbyWithRadius(
          Location(
            lat: currentLocation!.latitude!,
            lng: currentLocation!.longitude!,
          ),
          500,
        ),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          final PlacesSearchResponse details = snapshot.data!;
          final List<PlacesSearchResult> filteredResults = details.results
              .where((place) => place.rating != null && place.rating! >= 4)
              .toList();

          final List<PlacesSearchResult> sortedResults = List.of(filteredResults)
            ..sort((a, b) => b.rating!.compareTo(a.rating!));

          final List<PlacesSearchResult> topFiveResults =
          sortedResults.take(5).toList();
          return ListView.separated(
            physics: const BouncingScrollPhysics(),
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              final String placeId = topFiveResults[index].placeId;
              fetchDetails(placeId);
              return SizedBox(
                width: 220,
                child: GestureDetector(
                  onTap: () async {
                    PlacesDetailsResponse detail = await fetchDetails(placeId);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DetailsScreen(
                          details: detail,
                        ),
                      ),
                    );
                  },
                  child: Card(
                    elevation: 0.4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(12),
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Container(
                                child: Image.network(
                                  listChecker(
                                    filteredResults[index].photos,
                                  ),
                                  width: double.maxFinite,
                                  fit: BoxFit.cover,
                                  height: 150,
                                ),
                              ),
                            ),
                            const SizedBox(height: 5),
                            Row(
                              children: [
                                Flexible(
                                  child: Text(
                                    filteredResults[index].name,
                                    style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                    softWrap: false,
                                  ),
                                ),
                                const Spacer(),
                                Icon(
                                  Icons.star,
                                  color: Colors.yellow.shade700,
                                  size: 14,
                                ),
                                Text(
                                  filteredResults[index].rating.toString(),
                                  style: const TextStyle(
                                    fontSize: 12,
                                  ),
                                )
                              ],
                            ),
                            const SizedBox(height: 5),
                            Row(
                              children: [
                                const Icon(
                                  Icons.location_city,
                                  color: Color(0xFF008080),
                                  size: 16,
                                ),
                                const SizedBox(width: 5),
                                Text(
                                  filteredResults[index].types[0],
                                  style: const TextStyle(
                                    fontSize: 12,
                                  ),
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
            separatorBuilder: (context, index) => const Padding(
              padding: EdgeInsets.only(right: 10),
            ),
            itemCount: topFiveResults.length,
          );
        },
      ),
    );
  }
}