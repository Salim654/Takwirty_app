import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Models/Reservation.dart';
import '../Services/ApiClient.dart';
import '../Utils/Consts.dart';
import '../Widgets/AlertDialogDelete.dart';
import '../Widgets/MenuBar.dart';
import 'Profile.dart';
import 'login.dart';

class ReservationListScreen extends StatefulWidget {
  @override
  _ReservationListScreenState createState() => _ReservationListScreenState();
}

class _ReservationListScreenState extends State<ReservationListScreen> {
  late Future<List<Reservation>> futureReservation;

  int _selectedIndex = 1;
  bool _isSwitched = false;

  @override
  void initState() {
    super.initState();
    futureReservation = ApiClient.ReservationsEnAttente();
  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal.shade500,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child: Row(
              children: [
                if (_isSwitched)
                Text("Reservations Approve"),
                if (_isSwitched==false)
                  Text(" Reservations En Cours"),
                Switch(
                  value: _isSwitched,
                  onChanged: (value) {
                    setState(() {
                      _isSwitched = value;
                      if(_isSwitched)
                        {
                          futureReservation = ApiClient.ReservationsConfirmer();
                        }
                      else

                        {
                          futureReservation = ApiClient.ReservationsEnAttente();
                        }

                    });
                  },
                  activeTrackColor: Colors.limeAccent.shade200,
                  activeColor: Colors.limeAccent.shade700,
                ),
              ],
            ),
          ),
        ],
      ),
      drawer: buildMenuBar(selectedIndex: _selectedIndex),
      body: FutureBuilder<List<Reservation>>(
        future: futureReservation,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
  final reservation = snapshot.data![index];
  return InkWell(
  child: Stack(
    children: [
      Container(
        decoration: BoxDecoration(
          color: Colors.lightGreen.shade50,
          boxShadow: [
            BoxShadow(
              blurRadius: 4,
              color: Color(0x3600000F),
              offset: Offset(0, 2),
            )
          ],
          borderRadius: BorderRadius.circular(8),
        ),
        child: Padding(
          padding: EdgeInsets.all(12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '       ${reservation.terrain.nom}',
                    style: Theme.of(context).textTheme.headline6,
                  ),
                  Container(
                    height: 20,
                    width: 80,
                    decoration: BoxDecoration(
                      color: reservation.etat == 1 ? Colors.green : Colors.yellow,
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8.0,
                        vertical: 4,
                      ),
                      child: Text(
                        reservation.etat == 1 ? '   Approve' : ' En Attente',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Icon(
                    Icons.location_on,
                    size: 16,
                    color: Colors.grey,
                  ),
                  SizedBox(width: 4),
                  Text(
                    ' ${reservation.terrain.adresse}',
                    style: Theme.of(context).textTheme.bodyText2,
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                'TND ${reservation.terrain.prix}',
                style: Theme.of(context).textTheme.bodyText2,
              ),
              const SizedBox(height: 8),
              Text(
                '${reservation.date}',
                style: Theme.of(context).textTheme.bodyText2,
              ),
              const SizedBox(height: 8),
              Text(
                '${reservation.heure}:00',
                style: Theme.of(context).textTheme.bodyText2,
              ),
            ],
          ),
        ),
      ),
      if (reservation.etat == 0)
        Positioned(
          top: 0,
          right: 0,
          child: GestureDetector(
            onTap: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialogDelete(reservation.id);
                },
              );
            },
            child: Container(
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(8),
                  bottomLeft: Radius.circular(8),
                ),
              ),
              padding: const EdgeInsets.all(8),
              child: Image.asset(
            'assets/delete-icon.png',
            width: 100,
            height: 100,
          ),
            ),
          ),
        ),
    ],
  ),
);
},
            );

          } else if (snapshot.hasError) {
            return Center(
              child: Text('${snapshot.error}'),
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
      bottomNavigationBar: SalomonBottomBar(
          currentIndex: _selectedIndex,
          selectedItemColor: const Color(0xff6200ee),
          unselectedItemColor: const Color(0xff757575),
          onTap: (index) {
            setState(() {
              _selectedIndex = index;
              Consts.onItemTapped(context,_selectedIndex);
            });
          },
          items: Consts.navBarItems),


    );
  }

}
