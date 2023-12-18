import 'package:flutter/material.dart';
import 'package:flutter_simple_page/Services/ApiClient.dart';
import 'package:flutter_simple_page/Views/DateSelection.dart';
import 'package:flutter_simple_page/Views/Profile.dart';
import 'package:flutter_simple_page/Views/TerrainListScreen.dart';


class DetailTerrainScreen extends StatelessWidget {
  final Map<String, dynamic> terrain;

  const DetailTerrainScreen({required this.terrain});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
  body: Column(
    children: [
      Stack(
        children: [
          Image.network(
            "${ApiClient.baseUrl}/uploads/${terrain['image']}",
            width: MediaQuery.of(context).size.width,
            height: 200,
            fit: BoxFit.cover,
          ),
          Positioned(
            top: 40,
            left: 10,
            child: IconButton(
              icon: Icon(
                Icons.arrow_back_ios,
                color: Colors.black,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
          Positioned(
            top: 40,
            right: 10,
            child: IconButton(
              icon: Icon(
                Icons.favorite_border,
                color: Colors.black,
              ),
              onPressed: () {
                // handle favorite button press
              },
            ),
          ),
        ],
      ),
      Expanded(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                terrain['nom'],
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              Row(
                children: [
                  Icon(
                    Icons.location_on,
                    size: 16,
                    color: Colors.grey,
                  ),
                  SizedBox(width: 4),
                  Text(
                    terrain['adresse'],
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
              Text(
                'Description:',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              Text(
                terrain['description'],
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
              SizedBox(height: 16),
              Text(
                'Prix:',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'TND ${terrain['prix']}' ?? '',
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
              SizedBox(height: 32),
              Expanded(
                child: Container(),
              ),
              SizedBox(height: 16),
            ],
          ),
        ),
      ),
    ],
  ),
  floatingActionButton: FloatingActionButton.extended(
    onPressed: () async {
      List<String> avaiDates = await ApiClient.fetchAvailableDates(terrain['_id']);
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => DateSelection(terrain['_id'], avaiDates)),
      );
    },
    label: Text('Reserver'),
    icon: Icon(Icons.calendar_today),
    backgroundColor: Colors.teal.shade500,
  ),
  floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
);
  }
}
