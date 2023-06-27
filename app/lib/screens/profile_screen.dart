import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:porto_explorer/screens/signIn_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

import 'package:porto_explorer/screens/appLocalizations.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with SingleTickerProviderStateMixin {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late TabController _tabController;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String? name;
  String? email;
  String? username;
  double? pont;
  int? nrVisitedPoints;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    getUserData();
  }

  Future<void> getUserData() async {
    User? user = _auth.currentUser;

    if (user != null) {
      DocumentSnapshot snapshot =
      await _firestore.collection('users').doc(user.uid).get();

      if (snapshot.exists) {
        Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;

        setState(() {
          name = data['name'] as String;
          email = data['email'] as String;
          pont =
          data['score'] != null ? (data['score'] as num).toDouble() : 0.0;
          username = data['username'] as String;
          nrVisitedPoints = data['nrVisitedPoints'] != null
              ? data['nrVisitedPoints'] as int
              : 0;
        });
      }
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations appLocalizations = AppLocalizations.of(context)!;
    return Scaffold(
      key: const Key("profileScreen"),
      body: Stack(
        children: [
          Container(
            color: const Color(0xFFD9D9D9),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 40.0),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: MediaQuery
                        .of(context)
                        .size
                        .width * 0.9,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Align(
                                  alignment: Alignment.center,
                                  child: Text(
                                    name ?? '',
                                    style: const TextStyle(fontSize: 28),
                                  ),
                                ),
                                const SizedBox(height: 15),
                                Text(
                                  appLocalizations.translate("username") ?? "Username:",
                                  style: const TextStyle(fontSize: 15),
                                ),
                                Text(
                                  username ?? '',
                                  style: const TextStyle(fontSize: 17),
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  appLocalizations.translate("email") ?? "Email",
                                  style: const TextStyle(fontSize: 15),
                                ),
                                Text(
                                  email ?? '',
                                  style: const TextStyle(fontSize: 17),
                                ),
                              ],
                            ),
                          ),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: Image.network(
                              'https://upload.wikimedia.org/wikipedia/commons/3/34/PICA.jpg',
                              width: MediaQuery
                                  .of(context)
                                  .size
                                  .width * 0.35,
                              height: MediaQuery
                                  .of(context)
                                  .size
                                  .width * 0.35,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    width: MediaQuery
                        .of(context)
                        .size
                        .width * 0.9,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: TabBar(
                      controller: _tabController,
                      labelColor: Colors.white,
                      unselectedLabelColor: const Color(0xFF008080),
                      indicator: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: const Color(0xFF008080),
                      ),
                      tabs: [
                        Tab(
                            key: const Key("activityTabKey"),
                            text: appLocalizations.translate("activity") ?? "Activity"),
                        Tab(
                            key: const Key("visitedTabKey"),
                            text: appLocalizations.translate("visited") ?? "Visited"),
                      ],
                    ),
                  ),
                  Expanded(
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        ActivityTab(
                            key: const Key("activityTab"),
                            nrVisitedPoints: nrVisitedPoints ?? 0,
                            pont: pont ?? 0.0),
                        const VisitedTab(),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  GestureDetector(
                    key: const Key("signOutButton"),
                    onTap: () async {
                      await _auth.signOut();
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const SignInScreen()));
                    },
                    child: Container(

                      alignment: Alignment.center,
                      padding: const EdgeInsets.only(bottom: 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.logout,
                            size: 20,
                            color: Color(0xFF008080),
                          ),
                          const SizedBox(width: 0),
                          Text(
                            appLocalizations.translate("logOut") ?? "Log Out",
                            style: const TextStyle(
                              fontSize: 20,
                              color: Color(0xFF008080),
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}


class ActivityTab extends StatelessWidget {
  final int nrVisitedPoints;
  final double pont;

  const ActivityTab({
    Key? key,
    required this.nrVisitedPoints,
    required this.pont,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final AppLocalizations appLocalizations = AppLocalizations.of(context)!;
    double score = nrVisitedPoints.toDouble();

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width * 0.4,
                  height: MediaQuery.of(context).size.width * 0.4,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: FutureBuilder<int>(
                    builder:
                        (BuildContext context, AsyncSnapshot<int> snapshot) {
                      if (snapshot.connectionState ==
                          ConnectionState.waiting) {
                        return const Center(
                            child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(
                            child: Text('Error: ${snapshot.error}'));
                      } else {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                '$nrVisitedPoints',
                                key: const Key("nrVisitedPointsText"),
                                style: const TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              Text(
                                appLocalizations.translate("piVisited") ?? "points of interest visited",
                                style: const TextStyle(
                                  fontSize: 17,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        );
                      }
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Container(
                  width: MediaQuery.of(context).size.width * 0.4,
                  height: MediaQuery.of(context).size.width * 0.4,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        '$pont',
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      Text(
                        appLocalizations.translate("points") ?? "points",
                        style: const TextStyle(
                          fontSize: 17,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Container(
              width: MediaQuery.of(context).size.width * 0.87,
              height: MediaQuery.of(context).size.width * 0.2,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    appLocalizations.translate("visited") ?? "Visited:",
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(5),
                    child: SizedBox(
                      height: 16,
                      child: LinearProgressIndicator(
                        value: score / 400,
                        backgroundColor: Colors.grey[200],
                        valueColor: const AlwaysStoppedAnimation<Color>(
                          Color(0xFF008080),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

          ],
        ),
      ),
    );
  }
}


class VisitedTab extends StatelessWidget {
  const VisitedTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return const Center(
        child: Text(
          'Please log in to see the places visited.',
          style: TextStyle(fontSize: 20, color: Color(0xFF008080)),
        ),
      );
    }

    CollectionReference visitedPoints =
    FirebaseFirestore.instance.collection('VisitedPoints');
    Stream<QuerySnapshot> visitedStream =
    visitedPoints.where('userId', isEqualTo: user.uid).snapshots();

    return StreamBuilder<QuerySnapshot>(
      key: const Key("visitedWidgetKey"),
      stream: visitedStream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text('ERROR: ${snapshot.error}'));
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (BuildContext context, int index) {
              Map<String, dynamic> data =
              snapshot.data!.docs[index].data() as Map<String, dynamic>;
              return Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(10),
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: Image.network(
                      data['imageUrl'],
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                    ),
                  ),
                  title:
                  Text(data['name'], style: const TextStyle(fontSize: 16)),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(data['address'],
                          style: const TextStyle(fontSize: 14)),
                      Text('My Ranking: ${data['myRate']}',
                          style: const TextStyle(fontSize: 14)),
                      Text(
                        'Visit Day: ${DateFormat('dd/MM/yyyy HH:mm').format(data['timestamp'].toDate())}',
                        style: const TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}