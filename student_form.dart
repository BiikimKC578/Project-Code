
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'student.dart';
import 'student_service.dart';

class StudentForm extends StatefulWidget {
  final Student? student;

  const StudentForm({super.key, this.student});

  @override
  State<StudentForm> createState() => _StudentFormState();
}

class _StudentFormState extends State<StudentForm> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _khmerNameController;
  late TextEditingController _latinNameController;
  late String _gender;
  late DateTime _dob;
  late TextEditingController _addressController;
  late TextEditingController _telController;
  final StudentService service = StudentService();

  @override
  void initState() {
    super.initState();
    _khmerNameController = TextEditingController(text: widget.student?.khmerName ?? '');
    _latinNameController = TextEditingController(text: widget.student?.latinName ?? '');
    _gender = widget.student?.gender ?? 'male';
    _dob = widget.student?.dob ?? DateTime.now();
    _addressController = TextEditingController(text: widget.student?.address ?? '');
    _telController = TextEditingController(text: widget.student?.tel ?? '');
  }

  @override
  void dispose() {
    _khmerNameController.dispose();
    _latinNameController.dispose();
    _addressController.dispose();
    _telController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _dob,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _dob) {
      setState(() {
        _dob = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.student == null ? 'Add Student' : 'Edit Student'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _khmerNameController,
                decoration: const InputDecoration(labelText: 'Khmer Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a Khmer name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _latinNameController,
                decoration: const InputDecoration(labelText: 'Latin Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a Latin name';
                  }
                  return null;
                },
              ),
              DropdownButtonFormField<String>(
                value: _gender,
                decoration: const InputDecoration(labelText: 'Gender'),
                items: ['male', 'female', 'other'].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    _gender = newValue!;
                  });
                },
                validator: (value) {
                  if (value == null) {
                    return 'Please select a gender';
                  }
                  return null;
                },
              ),
              ListTile(
                title: Text('Date of Birth: ${DateFormat('yyyy-MM-dd').format(_dob)}'),
                trailing: const Icon(Icons.calendar_today),
                onTap: () => _selectDate(context),
              ),
              TextFormField(
                controller: _addressController,
                decoration: const InputDecoration(labelText: 'Address'),
              ),
              TextFormField(
                controller: _telController,
                decoration: const InputDecoration(labelText: 'Telephone'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    try {
                      Student newStudent = Student(
                        id: widget.student?.id,
                        khmerName: _khmerNameController.text,
                        latinName: _latinNameController.text,
                        gender: _gender,
                        dob: _dob,
                        address: _addressController.text,
                        tel: _telController.text,
                      );
                      if (widget.student == null) {
                        await service.createStudent(newStudent);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Student created successfully')),
                        );
                      } else {
                        await service.updateStudent(widget.student!.id!, newStudent);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Student updated successfully')),
                        );
                      }
                      Navigator.pop(context);
                    } catch (e) {
                      String errorMessage = 'Error: $e';
                      if (e.toString().contains('422')) {
                        errorMessage = 'Validation failed. Please check your inputs.';
                      }
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(errorMessage)),
                      );
                    }
                  }
                },
                child: Text(widget.student == null ? 'Create' : 'Update'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
