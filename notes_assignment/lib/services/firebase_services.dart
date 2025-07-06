import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseServices {
  // Initialize Firebase Auth and Firestore instances
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Get current user
  User? getCurrentUser() {
    return _auth.currentUser;
  }

  // Sign up with email and password
  Future<String?> signUp(String email, String password) async {
    try {
      // Create user with email and password
      await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return null; // Success, no error
    } catch (e) {
      return e.toString(); // Return error message
    }
  }

  // Sign in with email and password
  Future<String?> signIn(String email, String password) async {
    try {
      // Sign in user with email and password
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return null; // Success, no error
    } catch (e) {
      return e.toString(); // Return error message
    }
  }

  // Sign out user
  Future<void> signOut() async {
    await _auth.signOut();
  }

  // CREATE - Add a new note to Firestore
  Future<String?> addNote(String title, String content) async {
    try {
      // Get current user ID
      String userId = _auth.currentUser!.uid;
      
      // Add note document to 'notes' collection
      await _firestore.collection('notes').add({
        'title': title,           // Note title
        'content': content,       // Note content
        'userId': userId,         // Associate note with user
        'createdAt': FieldValue.serverTimestamp(), // Timestamp
      });
      return null; // Success, no error
    } catch (e) {
      return e.toString(); // Return error message
    }
  }

  // READ - Get all notes for current user
  Stream<QuerySnapshot> fetchNotes() {
    // Get current user ID
    String userId = _auth.currentUser!.uid;
    
    // Return stream of notes filtered by user ID, ordered by creation date
    return _firestore
        .collection('notes')
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  // UPDATE - Edit an existing note
  Future<String?> updateNote(String noteId, String title, String content) async {
    try {
      // Update the note document with new title and content
      await _firestore.collection('notes').doc(noteId).update({
        'title': title,
        'content': content,
        'updatedAt': FieldValue.serverTimestamp(), // Update timestamp
      });
      return null; // Success, no error
    } catch (e) {
      return e.toString(); // Return error message
    }
  }

  // DELETE - Remove a note from Firestore
  Future<String?> deleteNote(String noteId) async {
    try {
      // Delete the note document by ID
      await _firestore.collection('notes').doc(noteId).delete();
      return null; // Success, no error
    } catch (e) {
      return e.toString(); // Return error message
    }
  }
}