import 'package:flutter/material.dart';
import '../services/firebase_services.dart';

class EditNoteScreen extends StatefulWidget {
  final String noteId;
  final String title;
  final String content;

  EditNoteScreen({
    required this.noteId,
    required this.title,
    required this.content,
  });

  @override
  _EditNoteScreenState createState() => _EditNoteScreenState();
}

class _EditNoteScreenState extends State<EditNoteScreen> {
  // Controllers for title and content fields
  late TextEditingController _titleController;
  late TextEditingController _contentController;
  final FirebaseServices _firebaseServices = FirebaseServices();
  
  bool _isLoading = false; // Track loading state

  @override
  void initState() {
    super.initState();
    // Initialize controllers with existing note data
    _titleController = TextEditingController(text: widget.title);
    _contentController = TextEditingController(text: widget.content);
  }

  // Function to update the note
  Future<void> _updateNote() async {
    // Check if title is empty
    if (_titleController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter a title')),
      );
      return;
    }

    setState(() {
      _isLoading = true; // Show loading indicator
    });

    // Call Firebase update note method
    String? error = await _firebaseServices.updateNote(
      widget.noteId,
      _titleController.text.trim(),
      _contentController.text.trim(),
    );

    setState(() {
      _isLoading = false; // Hide loading indicator
    });

    if (error == null) {
      // Success - show success message and go back
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Note updated successfully!')),
      );
      Navigator.pop(context); // Go back to notes screen
    } else {
      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Note'),
        centerTitle: true,
        actions: [
          // Update button in app bar
          _isLoading
              ? Padding(
                  padding: EdgeInsets.all(16.0),
                  child: SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                )
              : IconButton(
                  icon: Icon(Icons.save),
                  onPressed: _updateNote,
                ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Title input field
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                labelText: 'Title',
                border: OutlineInputBorder(),
                filled: true,
                fillColor: Colors.white,
              ),
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            
            // Content input field
            Expanded(
              child: TextField(
                controller: _contentController,
                decoration: InputDecoration(
                  labelText: 'Content',
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.white,
                  alignLabelWithHint: true,
                ),
                maxLines: null,
                expands: true,
                textAlignVertical: TextAlignVertical.top,
              ),
            ),
            SizedBox(height: 16),
            
            // Update button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _updateNote,
                child: Text('Update Note'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFFFF59D), // Pastel yellow
                  padding: EdgeInsets.symmetric(vertical: 15),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    // Clean up controllers
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }
}