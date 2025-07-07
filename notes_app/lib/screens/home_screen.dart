import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';


import '/bloc/notes_bloc.dart';
import '/bloc/notes_event.dart';
import '/bloc/notes_state.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _noteController = TextEditingController();
  String? _editingNoteId;

  @override
  void initState() {
    super.initState();
    // small delay to ensure bloc is ready
    context.read<NotesBloc>().add(LoadNotes());
    
  }

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  void _showNoteDialog({String? id, String? initialText}) {
    _editingNoteId = id;
    _noteController.text = initialText ?? '';

    showDialog(
      context: context,
      builder: (context) => SingleChildScrollView(
        child: AlertDialog(
          title: Text(_editingNoteId == null ? 'Add Note' : 'Edit Note', style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.green,
          )),
          content: ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.2, // 20% of screen height
            ),
            child: TextField(
              controller: _noteController,
              decoration: InputDecoration(
                hintText: 'Enter your note',
                border: OutlineInputBorder(),
              ),
              maxLines: null, // Allows for unlimited lines
              keyboardType: TextInputType.multiline,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                if (_noteController.text.trim().isNotEmpty) {
                  if (_editingNoteId == null) {
                    context.read<NotesBloc>().add(AddNote(_noteController.text));
                  } else {
                    context.read<NotesBloc>().add(
                      UpdateNote(_editingNoteId!, _noteController.text),
                    );
                  }
                  Navigator.pop(context);
                }
              },
              child: Text('Save'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Notes', style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
        iconTheme: IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.pushReplacementNamed(context, '/login');
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => _showNoteDialog(),
      ),
      body: SafeArea(
        child: BlocBuilder<NotesBloc, NotesState>(
          builder: (context, state) {
            if (state is NotesLoading) {
              return Center(child: CircularProgressIndicator());
            }
        
          // ///  if (state is NotesError) {
          //     ScaffoldMessenger.of(context).showSnackBar(
          //       SnackBar(content: Text(state.message)),
          //     );
          //   }
        
            if (state is NotesLoaded) {
              final notes = state.notes;
        
              if (notes.isEmpty) {
                return Center(
                  child: Text(
                    'Nothing here yet—tap ➕ to add a note.', style: TextStyle(
                    color: Colors.red,
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                );
              }
        
              return ListView.builder(
                padding: EdgeInsets.all(16.0),
                physics: BouncingScrollPhysics(),
                shrinkWrap: true,
                itemCount: notes.length,
                itemBuilder: (context, index) {
                  final note = notes[index];
                  return Card(
                    elevation: 2,
                    margin: EdgeInsets.only(bottom: 12.0),
                    color: note['checked'] == true ? Colors.purple[250] : Colors.purple[100],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                      child: Row(
                        children: [
                          
                          // Note text
                          Expanded(
                            child: Text(
                              note['text'],
                              style: TextStyle(
                                fontSize: 16.0,
                                decoration: note['checked'] == true
                                  ? TextDecoration.lineThrough
                                  : TextDecoration.none,
                                color: note['checked'] == true
                                  ? Colors.green
                                  : Colors.black87,
                              ),
                            ),
                          ),
                          
                          // Edit and Delete buttons
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: Icon(Icons.edit, color: Colors.blue),
                                onPressed: () => _showNoteDialog(
                                  id: note['id'],
                                  initialText: note['text'],
                                ),
                              ),
                              IconButton(
                                icon: Icon(Icons.delete, color: Colors.red),
                                onPressed: () => context
                                    .read<NotesBloc>()
                                    .add(DeleteNote(note['id'])),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            }
        
            return SizedBox.shrink();
          },
        ),
      ),
    );
  }
}