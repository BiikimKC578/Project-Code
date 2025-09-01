
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'student.dart';

class StudentService {
  final String baseUrl = 'http://10.0.2.2:8000/api/students'; // Use 10.0.2.2 for Android emulator, or your IP for physical devices

  Future<List<Student>> getStudents() async {
    try {
      final response = await http.get(Uri.parse(baseUrl));
      if (response.statusCode == 200) {
        List jsonResponse = json.decode(response.body);
        return jsonResponse.map((student) => Student.fromJson(student)).toList();
      } else {
        throw Exception('Failed to load students: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  Future<Student> createStudent(Student student) async {
    try {
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(student.toJson()),
      );
      if (response.statusCode == 201) {
        return Student.fromJson(json.decode(response.body));
      } else if (response.statusCode == 422) {
        final errors = json.decode(response.body)['errors'];
        throw Exception('Validation failed: $errors');
      } else {
        throw Exception('Failed to create student: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  Future<Student> getStudent(int id) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/$id'));
      if (response.statusCode == 200) {
        return Student.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to load student: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  Future<Student> updateStudent(int id, Student student) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/$id'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(student.toJson()),
      );
      if (response.statusCode == 200) {
        return Student.fromJson(json.decode(response.body));
      } else if (response.statusCode == 422) {
        final errors = json.decode(response.body)['errors'];
        throw Exception('Validation failed: $errors');
      } else {
        throw Exception('Failed to update student: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  Future<void> deleteStudent(int id) async {
    try {
      final response = await http.delete(Uri.parse('$baseUrl/$id'));
      if (response.statusCode != 204) {
        throw Exception('Failed to delete student: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }
}
