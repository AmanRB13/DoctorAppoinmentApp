import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:docotorappointment/screens/appointments_screen.dart';
import 'package:docotorappointment/screens/doctor_details_screen.dart';
import 'package:docotorappointment/services/firestore_service.dart';

import 'package:firebase_auth/firebase_auth.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FirestoreService firestoreService = FirestoreService();

  final TextEditingController searchController =
      TextEditingController();

  String searchText = "";
  String selectedSpeciality = "All";
  final List<String> specialities = [
  "All",
  "Cardiologist",
  "Neurologist",
  "Dentist",
  "Dermatologist",
  "Pediatrician",
  "General Physician",
];


  @override
  Widget build(BuildContext context) {
    
    final user = FirebaseAuth.instance.currentUser;
    return Scaffold(
      drawer : Drawer(
        child: Container(
          child: ListView(
            children: [
              DrawerHeader(
                padding: EdgeInsets.zero,
                child: Row(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundImage: AssetImage('assets/images/aman.jpg')

                  ),
                  SizedBox(width: 10,),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                      Text('Aman',style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),),
                      Text('amanranabhat30@gmail.com',)
                    
                    ],),
                  ),
                ],
              )),
              ListTile(
                leading: ElevatedButton(
                  onPressed: (){
                    Navigator.pop(context);

                  },
                  child: Icon(Icons.home)),
                  title: Text('Home'),
                
              ),

              ListTile(leading: ElevatedButton(
                onPressed: (){
                  Navigator.pushReplacementNamed(context, '/details');

                },
                child: Icon(Icons.details)),
                title: Text('Details'),),
              ListTile(leading: ElevatedButton(
                onPressed: ()async{
                  await FirebaseAuth.instance.signOut();
                  Navigator.pushNamedAndRemoveUntil(context, '/', ((route) => false));

                },
                child: Icon(Icons.logout)),
                title: Text('Log Out'),),
            ],
          ),
        ),
        
      ),
      backgroundColor: Colors.grey.shade100,

      appBar: AppBar(
        backgroundColor: const Color(0xFF607D8B),
        title: const Text("Doctor Appointment"),
        centerTitle: true,
        actions: [
          IconButton(onPressed: (){
            Navigator.pushNamed(context, '/favorite');

          }, icon: Icon(Icons.favorite)),

          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, '/profile');
            },
            icon: const Icon(Icons.person),
          )
        ],
      ),

      body: Column(
        children: [

          /// SEARCH BAR
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
  controller: searchController,
  decoration: InputDecoration(
    hintText: "Search Doctors...",
    prefixIcon: const Icon(Icons.search),

    suffixIcon: searchController.text.isNotEmpty
        ? IconButton(
            icon: const Icon(Icons.close),
            onPressed: () {
              searchController.clear();
              setState(() {
                searchText = "";
              });
            },
          )
        : null,

    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
    ),
  ),
  onChanged: (value) {
    setState(() {
      searchText = value.toLowerCase();
    });
  },
),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: SizedBox(
              height: 50,

              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: specialities.length,
                itemBuilder: (context,index){
                  return ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: selectedSpeciality == specialities[index]
                      ? Colors.blue
                      : Colors.grey.shade300
                    ),
                    onPressed: (){
                    setState(() {
                      selectedSpeciality = specialities[index];
                    });
              
                  }, child: Text(specialities[index],
                  style: TextStyle(
                    color:  selectedSpeciality == specialities[index] 
                    ? Colors.white
                    : Colors.black,
                  ),)
                  );
              
              }),
            ),
          ),

          /// DOCTOR LIST
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: firestoreService.getDoctors(),
              builder: (context, snapshot) {

                if (snapshot.connectionState ==
                    ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if (!snapshot.hasData ||
                    snapshot.data!.docs.isEmpty) {
                  return const Center(
                    child: Text("No Doctors Available"),
                  );
                }

                final doctors = snapshot.data!.docs;

                final filteredDoctors =
                    doctors.where((doc) {
                  final doctor =
                      doc.data() as Map<String, dynamic>;

                  final name = doctor["name"]
                      .toString()
                      .toLowerCase();

                  final speciality = doctor["speciality"]
                      .toString()
                      .toLowerCase();

                 final matchesSearch =
    name.contains(searchText) ||
    speciality.contains(searchText);

final matchesFilter =
    selectedSpeciality == "All" ||
    speciality == selectedSpeciality.toLowerCase();

return matchesSearch && matchesFilter;
                }).toList();

                if (filteredDoctors.isEmpty) {
                  return const Center(
                    child: Text("No Doctor Found"),
                  );
                }

                return ListView.builder(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12),
                  itemCount: filteredDoctors.length,
                  itemBuilder: (context, index) {
                    final doctorDoc = filteredDoctors[index];
                  

                    final doctor =
                        doctorDoc.data()
                            as Map<String, dynamic>;

                    return Padding(
                      padding: const EdgeInsets.all(12.0),
                     
                        child: Card(
  child: Padding(
    padding: const EdgeInsets.all(12),
    child: Row(
      children: [
        CircleAvatar(
          radius: 35,
          backgroundImage: NetworkImage(doctor["image"] ?? ""),
        ),

        const SizedBox(width: 12),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                doctor["name"] ?? "",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              Text(doctor["speciality"] ?? ""),
              Text("Experience: ${doctor["experience"]}"),
              Text("Consultation Fee: ${doctor["fee"]}"),
            ],
          ),
        ),
Column(
  mainAxisSize: MainAxisSize.min,
  children: [
FutureBuilder<bool>(
  future:firestoreService.isfavorite(doctorId: doctorDoc.id, userId: FirebaseAuth.instance.currentUser!.uid) , builder: (context,snapshot){
    final bool  isfavorite = snapshot.data ?? false;
    return IconButton(onPressed: ()async{
      if(isfavorite){
        await firestoreService.removefavorites(doctorId: doctorDoc.id, userId: FirebaseAuth.instance.currentUser!.uid);
        



      }
      else{
        await firestoreService.addfavorites(userId: FirebaseAuth.instance.currentUser!.uid , doctorId: doctorDoc.id, doctor: Map<String,dynamic>.from(doctor));

      }
      setState(() {
        
      });

    }, icon: Icon(
      isfavorite
      ? Icons.favorite
      : Icons.favorite_border,
      color: Colors.red,));

  }),

    ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.lightGreenAccent,
        minimumSize: const Size(80, 35),
      ),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => DoctorDetailsScreen(
              doctor: doctor,
              doctorId: doctorDoc.id,
            ),
          ),
        );
      },
      child: const Text("View"),
    ),
  ],
)
      
      ],
    ),
  ),
)
                      
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),

      floatingActionButton:
          FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) =>
                  const AppointmentsScreen(),
            ),
          );
        },
        icon: const Icon(Icons.calendar_month),
        label: const Text("Appointments"),
      ),
    );
  }
}