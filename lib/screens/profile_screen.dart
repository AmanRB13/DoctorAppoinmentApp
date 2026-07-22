import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';

import 'package:provider/provider.dart';
import 'package:docotorappointment/providers/theme_providers.dart';


class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final  user= FirebaseAuth.instance.currentUser;
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        backgroundColor: Color(0xFF607D8B),
        title: Text('Profile'),
        centerTitle: true,

      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child:Column(
            
            children: [
               Expanded(
                 child: Center(
                   child: Column(
                    mainAxisSize: MainAxisSize.min,
                     children: [
                       CircleAvatar(radius: 50,
                        child: Icon(Icons.person,size: 60,),
                        ),
                        const SizedBox(height: 10,),
                        Text(user?.email ?? 'No Email',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 22,color: Colors.black),),
                     ],
                   ),
                 ),
               ),

               
             SwitchListTile(
  title: Text(
    themeProvider.isDarkMode
        ? 'Dark Mode'
        : 'Light Mode',
        style: TextStyle(color: Colors.black),
  ),

  secondary: Icon(
    themeProvider.isDarkMode
        ? Icons.dark_mode
        : Icons.light_mode,
        color: Colors.black,
  ),

  value: themeProvider.isDarkMode,

  onChanged: (value) {
    themeProvider.toggleTheme(value);
  },
),
        
              
              SizedBox(
                height: 50,
                width: double.infinity,
                
                child: ElevatedButton.icon(
                  style: ButtonStyle(
                    backgroundColor: WidgetStatePropertyAll(Colors.red),
                  ),
                
                  onPressed: ()async{
                    await FirebaseAuth.instance.signOut();
                    Navigator.pushNamedAndRemoveUntil(context, '/', (route)=>false);
                    
                  },
                icon: Icon(Icons.cancel,
                color: Colors.white,),
                 label: Text('LogOut')),
              )
              
            ],
          ),
        
      ),
    );
  }
}