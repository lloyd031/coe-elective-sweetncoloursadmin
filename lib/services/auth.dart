import 'package:firebase_auth/firebase_auth.dart';
import 'package:sweetncoloursadmin/models/user.dart';
import 'package:sweetncoloursadmin/services/database.dart';
 

class AuthService
{
  final FirebaseAuth _auth=FirebaseAuth.instance;
  //create user object based on firebase user
  // ignore: non_constant_identifier_names
  UserObj? _UserFromFirebase(User? user)
  {
    
    if (user!=null) {
      return UserObj(user.uid,user.email);
    } else {
      
      return null;
    }
  }
  //auth changed user stream 
  Stream<UserObj?> get user{
    return _auth.authStateChanges().map(_UserFromFirebase);
  }
  // signin anonymously
  Future signinAnon() async
  {
    try
    {
      UserCredential result = await _auth.signInAnonymously();
      User? user=result.user;
      return _UserFromFirebase(user);
    }catch(e)
    {
      return null;
    }
  }
  //signin with email and password
  Future signInWithEmailAndPassword(String email, String password) async
   {
      try{
          UserCredential result = await _auth.signInWithEmailAndPassword(email: email, password: password);
          User? user=result.user;
          
          return _UserFromFirebase(user);
      }catch(e)
      {
          return null;
      }
   }
   //signup with email and password
   Future registerWithEmailAndPassword(String email, String password,String fn, String ln, String profile, String accType) async
   {
      try{
          UserCredential result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
          User? user=result.user;
          //create a document for the user with uid in firebase
          await DatabaseService(user?.uid,user?.email,null).updateUserData(fn, ln, profile,accType);
          return _UserFromFirebase(user);
      }catch(e)
      {
          return null;
      }
   }
  //signout
  Future signOut() async
  { 
    try
    {
        return await _auth.signOut();
    }catch(e)
    {
        return null;
    }
  }

}