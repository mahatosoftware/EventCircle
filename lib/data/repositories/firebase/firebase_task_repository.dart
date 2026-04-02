import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/task_model.dart';
import '../task_repository.dart';

class FirebaseTaskRepository implements TaskRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static const String _collection = 'tasks';

  @override
  Stream<List<TaskModel>> getTasks(String eventId) {
    return _firestore
        .collection(_collection)
        .where('eventId', isEqualTo: eventId)
        .orderBy('title')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => TaskModel.fromJson(doc.data())).toList();
    });
  }

  @override
  Future<void> addTask(TaskModel task) async {
    await _firestore.collection(_collection).doc(task.id).set(task.toJson());
  }

  @override
  Future<void> updateTask(TaskModel task) async {
    await _firestore.collection(_collection).doc(task.id).update(task.toJson());
  }

  @override
  Future<void> deleteTask(String id) async {
    await _firestore.collection(_collection).doc(id).delete();
  }
}
