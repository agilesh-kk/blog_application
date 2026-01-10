import 'package:blog_app/core/errors/failure.dart';
import 'package:fpdart/fpdart.dart';

//creating interface for usecases in domain layer 
abstract interface class UseCase<SuccessType, Params>{
  Future<Either<Failure, SuccessType>> call(Params params);
}

class NoParams{}

