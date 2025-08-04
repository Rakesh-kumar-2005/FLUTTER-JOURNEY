import 'package:flutter/material.dart';
import 'package:notely/model/notes_model.dart';
import 'package:notely/screens/add_edit_screen.dart';
import 'package:notely/services/database_helper.dart';

class ViewNoteScreen extends StatelessWidget {

  final Note note;
  ViewNoteScreen({super.key, required this.note});

  final DatabaseHelper _databaseHelper = DatabaseHelper();

  String _formatDateTime(String dateTime) {
    final DateTime dt = DateTime.parse(dateTime);
    final now = DateTime.now();

    if (dt.year == now.year && dt.month == now.month && dt.day == now.day) {
      return 'Today ${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
    }

    return '${dt.day}/${dt.month}/${dt.year}, ${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';

  }



  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Color(int.parse(note.color),),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(onPressed: () => Navigator.pop(context), icon: Icon(Icons.arrow_back_ios_rounded, color: Colors.white,)),
        actions: [
          IconButton(
            icon: Icon(
              Icons.edit,
              color: Colors.white,
            ),
            onPressed: () async {
              await Navigator.push(context,
                MaterialPageRoute(builder: (context) => AddEditScreen(note: note)),
              );
            }
          ),
          SizedBox(width: 10,),
          IconButton(
            icon: Icon(
              Icons.delete,
              color: Colors.white,
            ),
            onPressed: () async {
              _showDeleteDialog(context);
            }
          )
        ],
      ),

      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(24, 16, 24, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(note.title,style: TextStyle(color: Colors.white,fontSize: 28,fontWeight: FontWeight.bold),),
                  SizedBox(height: 8,),
                  Row(
                    children: [
                      Icon(
                        Icons.access_time_filled,
                        size: 16,
                        color: Colors.white,
                      ),
                      SizedBox(width: 8,),
                      Text(_formatDateTime(note.dateTime),
                        style: TextStyle(color: Colors.white,fontSize: 16,fontWeight: FontWeight.w600),),

                    ],
                  )
                ],
              ),
            ),
            Expanded(
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.fromLTRB(24, 32, 24, 24),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(32),
                    topRight: Radius.circular(32),
                  ),
                ),

                child: SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  child: Text(
                    note.content,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 0.2,
                      height: 1.5,
                    ),
                  ),
                ),
              )
            )
          ],
        )
      )
    );
  }

  Future<void> _showDeleteDialog(BuildContext context) async {
    final confirm = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        scrollable: false,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Text(
          'Delete Note',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: Text('Are you sure you want to delete this note?',
          style: TextStyle(fontWeight: FontWeight.w500,
          color: Theme.of(context).colorScheme.primary,
          fontSize: 16),
        ),

        actions: [
          TextButton(
            child: Text('Cancel',),
            onPressed: () => Navigator.pop(context, false),
          ),
          TextButton(
            child: Text('Delete',style: TextStyle(color: Colors.red),),
            onPressed: () => Navigator.pop(context, true),
          ),
        ],
      ),
    );

    if(confirm) {
        await _databaseHelper.deleteNote(note.id!);
      Navigator.pop(context);
    }

  }
}
