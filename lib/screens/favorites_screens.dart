import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:docotorappointment/screens/doctor_details_screen.dart';
import 'package:docotorappointment/services/firestore_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class FavoriteScreen extends StatelessWidget {
  FavoriteScreen({super.key});

  final FirestoreService firestoreService = FirestoreService();

  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser!.uid;

    return Scaffold(
       backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        backgroundColor: const Color(0xFF607D8B),
        title: const Text("Favorite Doctors"),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: firestoreService.getfavorites(uid),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text("No favorite doctors"),
            );
          }

          final doctors = snapshot.data!.docs;

          return  ListView.builder(
  itemCount: doctors.length,
  itemBuilder: (context, index) {
    final doctorDoc = doctors[index];
    final doctor = doctorDoc.data() as Map<String, dynamic>;

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadiusGeometry.circular(12)),
      
      margin: const EdgeInsets.all(10),
      
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            CircleAvatar(
              radius: 35,
              backgroundImage: NetworkImage(
                doctor["image"] ?? "",
              ),
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
        ),
      ),
    );
  },
);
        },
      ),
    );
  }
}