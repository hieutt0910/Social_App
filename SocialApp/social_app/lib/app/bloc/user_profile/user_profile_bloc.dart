import 'package:bloc/bloc.dart';
import 'package:social_app/data/model/collection.dart';
import 'package:social_app/data/model/user.dart';

import 'user_profile_event.dart';
import 'user_profile_state.dart';


class UserProfileBloc extends Bloc<UserProfileEvent, UserProfileState> {
  UserProfileBloc() : super(UserProfileLoading()) {
    on<UserProfileDataRequested>(_onDataRequested);
  }

  Future<void> _onDataRequested(
      UserProfileDataRequested event,
      Emitter<UserProfileState> emit,
      ) async {
    emit(UserProfileLoading());
    try {
      // Dùng Future.wait để tải thông tin user và collections song song cho hiệu năng tốt hơn
      final results = await Future.wait([
        AppUser.getFromFirestore(event.userId),
        Collection.getUserCollections(event.userId),
      ]);

      final user = results[0] as AppUser?;
      final collections = results[1] as List<Collection>;

      if (user != null) {
        emit(UserProfileLoadSuccess(user: user, collections: collections));
      } else {
        emit(UserProfileLoadFailure("User not found."));
      }
    } catch (e) {
      emit(UserProfileLoadFailure(e.toString()));
    }
  }
}