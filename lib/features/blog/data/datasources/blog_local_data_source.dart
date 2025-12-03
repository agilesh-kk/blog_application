import 'package:blog_app/features/blog/data/models/blog_model.dart';
import 'package:hive/hive.dart';
//local storage is achieved using hive.

//interface for local storages
abstract interface class BlogLocalDataSource {
  void uploadlocalBlogs({required List<BlogModel> blogs});
  List<BlogModel> loadBlogs();
}

class BlogLocalDataSourceImpl implements BlogLocalDataSource{
  final Box box;
  BlogLocalDataSourceImpl(this.box);

  @override
  List<BlogModel> loadBlogs() {
    List<BlogModel> blogs = [];

    //retrieving the blogs from the local storage 
    box.read((){
      for(int i=0; i<box.length; i++){
        blogs.add(BlogModel.fromJson(box.get(i.toString()))); //the map is converted to a list
      }
    });

    return blogs;
  }

  @override
  void uploadlocalBlogs({required List<BlogModel> blogs}) {
    box.clear(); //clears the existing blogs

    //storing the blogs to the storage
    box.write((){
      for(int i=0;i<blogs.length;i++){
        box.put(i.toString(), blogs[i].toJson()); //the values are stored in json format
      }
    });
  }

}