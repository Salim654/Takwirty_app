import 'package:flutter/material.dart';
import 'package:flutter_simple_page/Services/ApiClient.dart';
import 'package:http/http.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';
import '../Utils/Consts.dart';
import 'TerrainListScreen.dart';

class Profile extends StatefulWidget {
  final int? respending;
  final int? resdone;

  const Profile({Key? key, this.respending, this.resdone}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  int? respending;
  int? resdone;
  String? _name = "";
  String? _last_name = "";
  String? _email = "";
  int? _phone = 0;
  int _selectedIndex = 2;

  @override
  void initState() {
    super.initState();
    resdone = widget.resdone;
    respending = widget.respending;

    ApiClient.fetchmyres().then((userProfile) {
      setState(() {
        resdone = userProfile['resdone'];
        respending = userProfile['respending'];
      });
    });

    ApiClient.fetchUserProfile().then((userProfile) {
      setState(() {
        _name = userProfile.name;
        _last_name = userProfile.last_name;
        _email = userProfile.email;
        _phone = userProfile.phone;
      });
    });
  }

  void _showEditDialog() {
    showDialog(
      context: context,
      builder: (context) {
        String? newPhoneNumber;
        return AlertDialog(
          title: Text("Edit Phone Number"),
          content: TextField(
            onChanged: (value) {
              newPhoneNumber = value;
            },
            decoration: InputDecoration(
              hintText: _phone != null ? _phone.toString() : "",
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () async {
               
                if (newPhoneNumber != null) {
                  
                  final response = await ApiClient.Editprofilenumber(int.parse(newPhoneNumber!));
                  if (response.statusCode == 200) {
               
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Phone updated Succefully"),
                    duration: Duration(seconds: 3),
                  ),
                  
                );
                 setState(() {
                    _phone = int.tryParse(newPhoneNumber!);
                  });
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Error."),
                    duration: Duration(seconds: 3),
                  ),
                );
              }
                 
                }
                Navigator.pop(context);
              },
              child: Text("Update"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const Expanded(flex: 2, child: _TopPortion()),
          Expanded(
            flex: 3,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Text(
                    _name ?? "",
                    style: Theme.of(context)
                        .textTheme
                        .headline6
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  _email != null
                      ? Text(_email ?? "")
                      : const CircularProgressIndicator(),
                  const SizedBox(height: 16),
                  _phone != null
                      ? Text(_phone.toString())
                      : const CircularProgressIndicator(),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _showEditDialog,
                    child: Text("Edit Phone Number"),
                  ),
                  const SizedBox(height: 16),
                  _ProfileInfoRow(resdone: resdone, respending: respending),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: SalomonBottomBar(
        currentIndex: _selectedIndex,
        selectedItemColor: const Color(0xff6200ee),
        unselectedItemColor: const Color(0xff757575),
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
            Consts.onItemTapped(context, _selectedIndex);
          });
        },
        items: Consts.navBarItems,
      ),
    );
  }
}

class _ProfileInfoRow extends StatelessWidget {
  final int? resdone;
  final int? respending;

  const _ProfileInfoRow({Key? key, this.resdone, this.respending}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<ProfileInfoItem> _items = [
      ProfileInfoItem("Réservation Apprové", resdone),
      ProfileInfoItem("Réservation En attente", respending),
    ];

    return Container(
      height: 80,
      constraints: const BoxConstraints(maxWidth: 400),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: _items
            .map((item) => Expanded(
                  child: Row(
                    children: [
                      if (_items.indexOf(item) != 0) const VerticalDivider(),
                      Expanded(child: _singleItem(context, item)),
                    ],
                  ),
                ))
            .toList(),
      ),
    );
  }

  Widget _singleItem(BuildContext context, ProfileInfoItem item) => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              item.value.toString(),
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ),
          Text(
            item.title,
            style: Theme.of(context).textTheme.caption,
          )
        ],
      );
}

class ProfileInfoItem {
  final String title;
  final int? value;
  ProfileInfoItem(this.title, this.value);
}

class _TopPortion extends StatelessWidget {
  const _TopPortion({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Container(
          margin: const EdgeInsets.only(bottom: 50),
          decoration: const BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [Color(0xFF00897B), Color(0xFF00897B)]),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(50),
                bottomRight: Radius.circular(50),
              )),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: SizedBox(
            width: 150,
            height: 150,
            child: Stack(
              fit: StackFit.expand,
              children: [
                Container(
                  decoration: const BoxDecoration(
                    color: Colors.black,
                    shape: BoxShape.circle,
                    image: DecorationImage(
                        fit: BoxFit.cover,
                        image: NetworkImage(
                            "${ApiClient.baseUrl}/uploads/person.jpg")),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: CircleAvatar(
                    radius: 20,
                    backgroundColor:
                        Theme.of(context).scaffoldBackgroundColor,
                    child: Container(
                      margin: const EdgeInsets.all(8.0),
                      decoration: const BoxDecoration(
                          color: Colors.green, shape: BoxShape.circle),
                    ),
                  ),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}
