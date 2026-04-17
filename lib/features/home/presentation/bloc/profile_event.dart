import 'package:equatable/equatable.dart';

abstract class ProfileEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadProfileEvent extends ProfileEvent {
  final String uid;

  LoadProfileEvent(this.uid);

  @override
  List<Object?> get props => [uid];
}

class LoadMyProfileEvent extends ProfileEvent {
  @override
  List<Object?> get props => [];
}

class RefreshProfileEvent extends ProfileEvent {
  @override
  List<Object?> get props => [];
}