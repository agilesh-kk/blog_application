import 'package:blog_app/core/theme/app_pallete.dart';
import 'package:blog_app/core/utils/calculate_reading_time.dart';
import 'package:blog_app/core/utils/date_format.dart';
import 'package:blog_app/features/blog/domain/entities/blog.dart';
import 'package:blog_app/features/blog/domain/entities/users.dart';
import 'package:blog_app/features/blog/presentation/pages/poster_page.dart';
import 'package:blog_app/features/blog/presentation/pages/your_profile_page.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:blog_app/core/common/cubits/app%20user/app_user_cubit.dart';

class BlogViewerPage extends StatelessWidget {
  static const String pageName = '/blog-viewer';
  final Blog blog; //requesting the blog
  const BlogViewerPage({super.key, required this.blog});

  @override
  Widget build(BuildContext context) {
    final appUserState = context.watch<AppUserCubit>().state;
    final posterName = blog.posterName ?? 'Unknown';
    return Scaffold(
      appBar: AppBar(
        //title of the blog
        title: Text(
          blog.title,
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
      body: Scrollbar(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),

                //name of the poster
                GestureDetector(
                  onTap: (){
                    if(appUserState is AppUserIsSignedin){
                      if(appUserState.user.id == blog.posterId){
                        context.goNamed(YourProfilePage.pageName);
                      }
                      else{
                        context.pushNamed(
                          PosterPage.pageName, 
                          extra: Users(
                            id: blog.posterId, 
                            name: posterName,
                          )
                        );
                      }
                    }
                  },
                  child: Text(
                    'By ${blog.posterName}',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                  ),
                ),
                const SizedBox(height: 8),

                //date of upload and reading time of the blog
                Text(
                  '${formatDateddMMMYYYY(blog.updatedAt)} . ${calculateReadingTime(blog.content)} min',
                  style: TextStyle(
                    color: AppPallete.greyColor,
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 15),

                //image of the blog
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: CachedNetworkImage(
                    // The URL from your Hive/Supabase model
                    imageUrl: blog.imageUrl,

                    // What to show while loading
                    placeholder:
                        (context, url) =>
                            const Center(child: CircularProgressIndicator()),

                    // CRITICAL: What to show if offline/error
                    errorWidget:
                        (context, url, error) => const Center(
                          child: Icon(
                            Icons.cloud_off,
                            size: 50,
                            color: Colors.grey,
                          ),
                        ),

                    // Optional: Make it look nice
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(height: 15),

                //content of the blog
                Text(blog.content, style: TextStyle(fontSize: 16, height: 2)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
