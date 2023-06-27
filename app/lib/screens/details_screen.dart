import 'package:flutter/material.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../reusable_widgets/reusable_widget.dart';


import 'appLocalizations.dart';

class DetailsScreen extends StatefulWidget {
  final PlacesDetailsResponse details;

  const DetailsScreen({Key? key, required this.details}) : super(key: key);

  @override
  DetailsScreenState createState() => DetailsScreenState();
}

class DetailsScreenState extends State<DetailsScreen> {
  bool isVisited = false;

  @override
  void initState() {
    super.initState();
    checkIfVisited();
  }

  void checkIfVisited() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      CollectionReference visitedPoints =
      FirebaseFirestore.instance.collection('VisitedPoints');
      QuerySnapshot querySnapshot = await visitedPoints
          .where('userId', isEqualTo: user.uid)
          .where('placeId', isEqualTo: widget.details.result.placeId)
          .get();
      setState(() {
        isVisited = querySnapshot.docs.isNotEmpty;
      });
    }
  }

  String isOpen(bool open) {
    if (open) {
      return "yes";
    } else {
      return "no";
    }
  }

  String getImage(Photo photoReference) {
    const baseUrl =
        "https://maps.googleapis.com/maps/api/place/photo?maxwidth=400";
    String s = photoReference.photoReference;
    final url =
        "$baseUrl&photoreference=$s&key=AIzaSyDI3VdZjuu7hxVvPlA2XaU78Px8BepEdyQ";
    return url;
  }

  void markAsVisited(PlacesDetailsResponse details) async {
    if (isVisited) {
      return;
    }

    User? user = FirebaseAuth.instance.currentUser;

    String imageUrl = details.result.photos.isNotEmpty
        ? getImage(details.result.photos[0])
        : 'https://upload.wikimedia.org/wikipedia/commons/d/d1/Image_not_available.png';

    if (user != null) {
      int rating = 0;

      await showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text('Rate this place'),
                      const SizedBox(height: 10.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [ for (int i = 1; i <= 5; i++)
                          GestureDetector(
                              onTap: () {
                                setState(() {
                                  rating = i;
                                });
                              },

                              child: Icon(
                                Icons.star,
                                size: 30.0,
                                color: i <= rating
                                    ? const Color(0xFFDAA520)
                                    : Colors.grey,
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 20.0),
                      ElevatedButton(
                        onPressed: () async {
                          CollectionReference visitedPoints = FirebaseFirestore.instance.collection('VisitedPoints');
                          int scoreIncrement = details.result.rating != null ? details.result.rating?.toInt() ?? 3 : 3;

                          await visitedPoints.add({
                            'userId': user.uid,
                            'placeId': details.result.placeId,
                            'name': details.result.name,
                            'address': details.result.formattedAddress,
                            'rating': details.result.rating,
                            'types': details.result.types,
                            'visited': true,
                            'imageUrl': imageUrl,
                            'myRate': rating,
                            'timestamp': FieldValue.serverTimestamp(),
                          });

                          DocumentReference userRef = FirebaseFirestore.instance.collection('users').doc(user.uid);

                          await userRef.update({
                            'score': FieldValue.increment(scoreIncrement),
                            'nrVisitedPoints': FieldValue.increment(1),
                          });

                          setState(() {
                            isVisited = true;
                          });

                          Navigator.of(context).pop();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF008080),
                        ),
                        child: const Text(
                          'Submit',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          );
        },
      );
    } else {
      print('No user is signed in.');
    }
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    String listChecker(List<Photo> lst) {
      if (lst.isNotEmpty) {
        return getImage(lst[0]);
      } else {
        return "https://upload.wikimedia.org/wikipedia/commons/d/d1/Image_not_available.png";
      }
    }
    final AppLocalizations appLocalizations = AppLocalizations.of(context)!;

    return Scaffold(
      key: const Key("detailsPageKey"),
      body: Stack(
        children: [
          SizedBox(
            height: height / 2.2,
            child: AspectRatio(
              aspectRatio: 16 / 9,
              child: Image.network(
                listChecker(widget.details.result.photos),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Positioned(
            top: 50.0,
            left: 20.0,
            child: GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Container(
                height: 40.0,
                width: 40.0,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    color: Colors.white),
                child: const Icon(Icons.arrow_back),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: height / 2.4),
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            height: height,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30.0),
                topRight: Radius.circular(30.0),
              ),
              color: Colors.white,
            ),
            child: ListView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.only(top: 20.0),
              children: [
                Text(
                  widget.details.result.name,
                  style: const TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5.0),
                Text(
                  widget.details.result.formattedAddress ?? '',
                  style: const TextStyle(
                    color: Colors.grey,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(height: 20.0),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: [
                    for (int i = 0; i < widget.details.result.types.length; i++)
                      Container(
                        constraints: const BoxConstraints(maxWidth: 200),
                        height: 25.0,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10.0, vertical: 5.0),
                        margin: const EdgeInsets.only(right: 10.0),
                        color: Colors.grey.withOpacity(0.2),
                        child: Text(widget.details.result.types[i]),
                      ),
                  ],
                ),
                const SizedBox(height: 20.0),
                Text(
                  widget.details.result.vicinity ?? '',
                  style: const TextStyle(
                    color: Colors.grey,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const Divider(
                  thickness: 1,
                  height: 40.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const SizedBox(width: 1),
                    tagButton(
                      text:appLocalizations.translate("rating") ?? "Rating",
                      value: widget.details.result.rating.toString(),
                      iconData:
                      const IconData(0xe5fa, fontFamily: 'MaterialIcons'),
                    ),
                    const SizedBox(width: 18),
                    tagButton(
                      text:appLocalizations.translate("reviews") ?? "Reviews",
                      value: widget.details.result.reviews.length.toString(),
                      iconData:
                      const IconData(0xe537, fontFamily: 'MaterialIcons'),
                    ),
                    const SizedBox(width: 1),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        child: Container(
          height: 60.0,
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                blurRadius: 20.0,
                offset: const Offset(0, 5),
                color: Colors.black.withOpacity(0.15),
              ),
            ],
            color: Colors.white,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                child: Container(
                  height: 40.0,
                  padding: const EdgeInsets.symmetric(horizontal: 30.0),
                  decoration: BoxDecoration(
                    color: const Color(0xFF008080),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Center(
                    child: Text(
                      appLocalizations.translate("directions") ?? "directions",
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16.0,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 5),
              GestureDetector(
                key: const Key("visitedButton"),
                onTap: () {
                  markAsVisited(widget.details);
                },
                child: Container(
                  height: 40.0,
                  width: 120.0,
                  padding: const EdgeInsets.symmetric(horizontal: 30.0),
                  decoration: BoxDecoration(
                    color: const Color(0xFF008080),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Center(
                    child: isVisited
                        ? const Icon(
                      Icons.check,
                      color: Colors.white,
                    )
                        : Text(
                      appLocalizations.translate("visited") ?? "visited",
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16.0,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}